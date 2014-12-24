きょうは会社休みます。
===============

## これは何？

指定した時間にメールするやつ

## 必要なもの

- nkf
- at
- perl
- sendmail(postfix)

## 使い方

1. `schedule.txt`に送る日付,宛先,メール本文を入力する
2. `bin/sendmail.pl`のfromアドレスを変更する
3. `mail/kekkin.eml`にメール本文を書く(1行目はSubject)
4. `kaisya.pl`実行する
