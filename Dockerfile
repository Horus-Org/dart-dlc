# syntax=docker/dockerfile:1

FROM dart:latest
FROM dart-dlc:1.0.10
FROM ldk-node-flutter:0.3.0
FROM bdk:0.31.2
RUN git clone https://github.com/Horus-Org-dart-dlc.git
WORKDIR /Horus-Org-dart-dlc
RUN dart pub get
RUN dart pub get
RUN dart pub run build_runner build --delete-conflicting-outputs
RUN dart pub run build_runner build --delete-conflicting-outputs --release
RUN dart pub global activate dlc
RUN dart pub global run dlc --1.0.10
RUN dart pub global run dlc --1.0.10--release

