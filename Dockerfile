FROM ubuntu:latest

RUN yes | unminimize
RUN apt-get update && \
  apt-get install -y \
  locales \
  neovim \
  less \
  zsh \
  curl \
  git \
  gnupg && \
  chsh -s /bin/zsh && \
  locale-gen ja_JP.UTF-8
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
ENV LANG=ja_JP.UTF-8
ENV TZ=Asia/Tokyo
WORKDIR /app

# docker build -t passmane
# docker run -it -v $(pwd):/app passmane
# docker exec -it コンテナID zsh
# パスワードはpassword


# これでキーを確認
# gpg --list-keys
# gpg --list-secret-keys
# キー作成
# gpg --gen-key
# gpg -e -r test@.com passwords.txt
# gpg -d passwords.txt.gpg
