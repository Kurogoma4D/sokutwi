git clone https://github.com/flutter/flutter.git

flutter/bin/flutter config --enable-web
flutter/bin/flutter build web --dart-define flavor=prod --web-renderer canvaskit
