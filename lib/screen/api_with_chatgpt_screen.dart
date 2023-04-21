import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:chat_api_app/screen/api_with_line_chart.dart';
import 'package:http/http.dart' as http;
import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:chat_api_app/components/app_theme.dart';

class ApiWithChatGPTScreen extends StatefulWidget {
  const ApiWithChatGPTScreen({Key? key}) : super(key: key);

  @override
  State<ApiWithChatGPTScreen> createState() => _ApiWithChatGPTScreenState();
}

class _ApiWithChatGPTScreenState extends State<ApiWithChatGPTScreen> {
  final kosisApiKey = dotenv.get('KosisApiKey');
  final kosisApiId = dotenv.get('KosisApiId');

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage('## 반갑습니다. 전 ChatGPT입니다.', false, false));
  }

  void _getApiDatas() async {
    // https://kosis.kr/statHtml/statHtml.do?orgId=116&tblId=DT_MLTM_2082
    // 'https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=${kosisApiKey}&format=json&jsonVD=Y&userStatsId=ocw2scw/116/DT_MLTM_2082/2/1/20230110105334&prdSe=M&newEstPrdCnt=1';
    // 'https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=${kosisApiKey}&format=json&jsonVD=Y&userStatsId=ocw2scw/116/DT_MLTM_2082/2/1/20230404083430&prdSe=M&newEstPrdCnt=1';
    final url =
        'https://kosis.kr/openapi/statisticsData.do?method=getList&apiKey=$kosisApiKey&format=json&jsonVD=Y&userStatsId=$kosisApiId/116/DT_MLTM_2082/2/1/20230404111619&prdSe=M&newEstPrdCnt=3';

    Map<String, String> headers = {
      'key': 'Access-Control-Allow-Origin',
      'value': '*',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      // final response = await http.get(Uri.parse(url));
      print(response.statusCode);
      print('response.body: ${response.body}');
      var datas = json.decode(response.body);
      // var _apiContent = '아래 표는 대한민국 시・군・구별 미분양현황입니다.\n';
      var apiContent = """ 
아래 표는 대한민국의 기간에 따른 지역별 미분양 수 변화 입니다.

|지역|연월|미분양 수|
|---|---|---|
""";

      for (var data in datas) {
        apiContent =
            '$apiContent|${data['C1_NM']}|${data['PRD_DE'].toString().substring(0, 4)}.${data['PRD_DE'].toString().substring(4, 6)}|${data['DT']}|\n';
      }
      // print(_apiContent);
      // _apiContent = '${_apiContent}\n 기간 오름차순과 미분양수가 많은 순서로 표로 보여주고 분석해줘';
      // _apiContent = '${_apiContent}\n중요한 내용 요약하고 분석해줘';
      apiContent = """
$apiContent
년월별 전체 미분양수 알고 싶어요
미분양수가 가장 많은 지역 알고 싶어요
미분양수가 가장 많이 증가한 지역 알고 싶어요
그외 중요한 내용 요약하고 분석해주세요
""";
      setState(() {
        _messages.add(ChatMessage(apiContent, true, false));
        _messages.add(ChatMessage('', false, true)); // 차트 보여주기
      });
      _onStreamSubmitted('');
      print(apiContent);
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 700), curve: Curves.ease);
    } catch (e) {
      print(e);
    }
  }

  final _messages = <ChatMessage>[];
  var _awaitingResponse = false;
  var _stramMsg = ''; // 스트림 버블 메시지
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChatGPT')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              // padding: EdgeInsets.only(bottom: 48),
              controller: _scrollController,
              children: [
                ..._messages.map(
                  (msg) => MessageBubble(
                    content: msg.content,
                    isUserMessage: msg.isUserMessage,
                    isShowChart: msg.isShowChart,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FloatingActionButton.extended(
                      heroTag: "hero1",
                      backgroundColor: AppTheme.darkGrey.withOpacity(0.9),
                      onPressed: _getApiDatas,
                      label: Text(
                        '시・군・구별 미분양현황',
                        style: AppTheme.gptAIP,
                      ),
                      // icon: const Icon(Icons.library_books_outlined,
                      //     size: 24, color: AppTheme.nearlyWhite),
                    ),
                    const SizedBox(width: 16),
                    FloatingActionButton.extended(
                      heroTag: "hero2",
                      backgroundColor: AppTheme.darkGrey.withOpacity(0.9),
                      onPressed: () {},
                      label: Text(
                        '보이는 GPT',
                        style: AppTheme.gptAIP,
                      ),
                      icon: const Icon(Icons.more,
                          size: 24, color: AppTheme.nearlyWhite),
                    ),
                  ],
                ),
                Container(
                  height: 32,
                )
              ],
            ),
          ),
          MessageComposer(
            onSubmitted: _onStreamSubmitted,
            awaitingResponse: _awaitingResponse,
          ),
        ],
      ),
    );
  }

  Future<void> _onStreamSubmitted(String message) async {
    setState(() {
      if (message.isNotEmpty) {
        _messages.add(ChatMessage(message, true, false)); // 보내는 메시지(이번 사용자 입력분)
      }
      _messages.add(ChatMessage('', false, false)); // 답변 버블쳇창 미리 만들기
      _awaitingResponse = true;
    });
    OpenAI.apiKey = dotenv.get('OpenApiKey');
    final chatStream = OpenAI.instance.chat.createStream(
      model: "gpt-3.5-turbo",
      messages: _messages
          .map((e) => OpenAIChatCompletionChoiceMessageModel(
                role: e.isUserMessage
                    ? OpenAIChatMessageRole.user
                    : OpenAIChatMessageRole.assistant,
                content: e.content,
              ))
          .toList(),
    );

    // Listen to the stream.
    chatStream.listen(
      (streamChatCompletion) {
        final contentStream = streamChatCompletion.choices.first.delta.content;
        if (contentStream != null) {
          if (_stramMsg == '') _stramMsg = '## ';
          _stramMsg = '$_stramMsg$contentStream';
          setState(() {
            _awaitingResponse = false;
            _messages.last = ChatMessage(_stramMsg, false, false); // 답변 타이핑 효과
          });
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 700),
              curve: Curves.ease);
        }
      },
      onError: (error) {
        print("onError");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
        setState(() {
          _stramMsg = '';
          _awaitingResponse = false;
        });
      },
      cancelOnError: false,
      onDone: () {
        print("onDone");
        print(_stramMsg);
        setState(() {
          _stramMsg = '';
          _awaitingResponse = false;
        });
      },
    );
  }
}

class ChatMessage {
  ChatMessage(this.content, this.isUserMessage, this.isShowChart);

  late final String content;
  final bool isUserMessage;
  final bool isShowChart;
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.content,
    required this.isUserMessage,
    required this.isShowChart,
    super.key,
  });

  final String content;
  final bool isUserMessage;
  final bool isShowChart;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isUserMessage
            // ? themeData.colorScheme.primary.withOpacity(0.4)
            // : themeData.colorScheme.secondary.withOpacity(0.4),
            ? Colors.grey.shade200
            : AppTheme.kDarkGreenColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isUserMessage ? 'You' : 'AI',
                  style: isUserMessage ? AppTheme.signForm : AppTheme.inButton,
                  // style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: content));
                    },
                    icon: Icon(
                      Icons.copy,
                      size: 18,
                      color: isUserMessage
                          ? AppTheme.kDarkGreenColor
                          : AppTheme.nearlyWhite,
                    )),
              ],
            ),
            const SizedBox(height: 8),
            isShowChart
                ? ApiWithLineChart()
                : MarkdownBody(
                    data: content,
                    selectable: true,
                    // shrinkWrap: true,
                    styleSheet: isUserMessage
                        ? MarkdownStyleSheet(
                            h1: AppTheme.gptUserP,
                            h2: AppTheme.gptUserP,
                            p: AppTheme.gptUserP,
                            tableBody: AppTheme.gptUserTableBody,
                            blockquote: AppTheme.gptUserP,
                            listBullet: AppTheme.gptUserP,
                            // tableColumnWidth: const FixedColumnWidth(200),
                            // 'th': tableHead,
                            // 'tr': tableBody,
                            // 'td': tableBody,
                          )
                        : MarkdownStyleSheet(
                            h1: AppTheme.gptAIP,
                            h2: AppTheme.gptAIP,
                            p: AppTheme.gptAIP,
                            tableBody: AppTheme.gptAITableBody,
                            blockquote: AppTheme.gptAIP,
                            listBullet: AppTheme.gptAIP,
                            // 'th': tableHead,
                            // 'tr': tableBody,
                            // 'td': tableBody,
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}

class MessageComposer extends StatelessWidget {
  MessageComposer({
    required this.onSubmitted,
    required this.awaitingResponse,
    super.key,
  });

  final TextEditingController _messageController = TextEditingController();

  final void Function(String) onSubmitted;
  final bool awaitingResponse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.05),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: !awaitingResponse
                  ? TextField(
                      controller: _messageController,
                      onSubmitted: onSubmitted,
                      decoration: const InputDecoration(
                        hintText: '여기에 메시지를 입력 하세요...',
                        border: InputBorder.none,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          // child: Text('Fetching response...'),
                          child: Text('답변 작성중입니다...'),
                        ),
                      ],
                    ),
            ),
            IconButton(
              onPressed: !awaitingResponse
                  ? () => onSubmitted(_messageController.text)
                  : null,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}

/*
아래 표는 대한민국의 기간에 따른 지역별 미분양 누적수 현황 입니다.
|해당년월|미분양 수(호)|시군구|
|---|---|---|
|202209|719호|서울|
|202210|866호|서울|
|202211|865호|서울|
|202212|953호|서울|
|202301|996호|서울|
|202209|1973호|부산|
|202210|2514호|부산|
|202211|2574호|부산|
|202212|2640호|부산|
|202301|2646호|부산|
|202209|10539호|대구|
|202210|10830호|대구|
|202211|11700호|대구|
|202212|13445호|대구|
|202301|13565호|대구|
|202209|1541호|인천|
|202210|1666호|인천|
|202211|2471호|인천|
|202212|2494호|인천|
|202301|3209호|인천|
|202209|163호|광주|
|202210|161호|광주|
|202211|161호|광주|
|202212|291호|광주|
|202301|262호|광주|

위는 대한민국의 기간에 따른 지역별 미분양수 추이 입니다.
년월별 전체 미분양수 알고 싶어요
미분양수가 가장 많은 지역 알고 싶어요
미분양수가 가장 많이 증가한 지역 알고 싶어요
그외 중요한 내용 요약하고 분석해주세요

*/