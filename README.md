# chatapiapp

flutter doctor -v
flutter channel
flutter channel stable
flutter upgrade

flutter clean 
flutter pub get


flutter config --enable-web
flutter build web
flutter build web --base-href "/chatapiweb/"


copy .env

flutter create --platforms=android .

```
flutter run -d chrome --web-browser-flag "--disable-web-security”
```