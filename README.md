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



flutter build web --base-href "/chatapiweb/"
cd ./build/web
git init
git remote add origin https://github.com/5712labs/chatapiweb.git
git add .
git commit -m "Installed WebPages"
git push origin master