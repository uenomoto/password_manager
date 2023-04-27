#!/bin/zsh

source .env

echo "パスワードマネージャーへようこそ！"
preservation_file="passwords.txt"
encrypted_file="passwords.gpg"

# 復号化されたファイルが存在する場合は削除
if [ -f $preservation_file ]; then
    rm $preservation_file
fi

# 暗号化されたファイルを復号化
gpg --output $preservation_file --decrypt $encrypted_file

while true; do
  echo "次の選択肢から入力してください(Add Password/Get Password/Exit): "
  read mode

  if [ "$mode" = "Add Password" ]; then
    gpg -d -o $preservation_file $encrypted_file 2> /dev/null

    echo "サービス名を入力してください："
    read service_name
    echo "ユーザー名を入力してください："
    read username
    echo "パスワードを入力してください："
    read password

    echo "${service_name}:${username}:${password}" >> $preservation_file
    # ファイルを暗号化し、復号化されたファイルを削除
    gpg -e -r $MY_EMAIL -o $encrypted_file $preservation_file
    rm $preservation_file
    echo "パスワードの追加は成功しました。"

  elif [ "$mode" = "Get Password" ]; then
    echo "サービス名を入力してください："
    read service_name

    gpg -d -o $preservation_file $encrypted_file
    result=$(grep "^$service_name:" $preservation_file)

    if [ -z "$result" ]; then
      echo "そのサービスは登録されていません。"
    else
      echo "サービス名：$service_name"
      username=$(grep "^$service_name:" $preservation_file | cut -f 2 -d ":")
      echo "ユーザー名：$username"
      password=$(grep "^$service_name:" $preservation_file | cut -f 3 -d ":")
      echo "パスワード：$password"
    fi
    rm $preservation_file

  elif [ "$mode" = "Exit" ]; then
    echo "Thank you!"
    break

  else
    echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
  fi
done
