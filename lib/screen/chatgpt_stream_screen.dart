import 'dart:async';
import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:chat_api_app/components/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatGPTStreamScreen extends StatefulWidget {
  const ChatGPTStreamScreen({super.key});

  @override
  State<ChatGPTStreamScreen> createState() => _ChatGPTStreamScreenState();
}

class _ChatGPTStreamScreenState extends State<ChatGPTStreamScreen> {
  final _messages = <ChatMessage>[
    ChatMessage('반갑습니다. 전 ChatGPT입니다.', false),
  ];
  var _awaitingResponse = false;
  var _stramMsg = ''; // 스트림 버블 메시지

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChatGPT')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ..._messages.map(
                  (msg) => MessageBubble(
                    content: msg.content,
                    isUserMessage: msg.isUserMessage,
                  ),
                ),
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
      _messages.add(ChatMessage(message, true)); // 보내는 메시지(이번 사용자 입력분)
      _messages.add(ChatMessage('', false)); // 답변 버블쳇창 미리 만들기
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
          _stramMsg = '$_stramMsg$contentStream';
          setState(() {
            _awaitingResponse = false;
            _messages.last = ChatMessage(_stramMsg, false); // 답변 타이핑 효과
          });
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
        setState(() {
          _stramMsg = '';
          _awaitingResponse = false;
        });
      },
    );
  }
}

class ChatMessage {
  ChatMessage(this.content, this.isUserMessage);

  late final String content;
  final bool isUserMessage;
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.content,
    required this.isUserMessage,
    super.key,
  });

  final String content;
  final bool isUserMessage;

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
              children: [
                Text(
                  isUserMessage ? 'You' : 'AI',
                  style: isUserMessage ? AppTheme.signForm : AppTheme.inButton,
                  // style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: isUserMessage ? AppTheme.signForm : AppTheme.inButton,
            ),
            // MarkdownWidget(
            //   data: content,
            //   shrinkWrap: true,
            // ),
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
