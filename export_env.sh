#!/bin/bash

export $(cat .env | xargs)
flutter pub run environment_config:generate
