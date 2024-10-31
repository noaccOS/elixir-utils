#!/bin/sh

function elixir_vers() {
    echo '{'
    git ls-remote --tags --refs https://github.com/elixir-lang/elixir.git |
        sort -V -u -r -k2 |
        sed '/refs\/tags\/main-latest/d' |
        sed -r 's/^(\w+)\s+(refs\/tags\/v(([0-9]+)\.([0-9]+).*))$/"\3":{"rev":"\1","ref":"\2","version":"\3","minor":"\4_\5"}/' |
        paste -sd ','
    echo '}'
}
function erlang_vers() {
    echo '{'
    git ls-remote --tags --refs https://github.com/erlang/otp.git 'OTP-*'|
        sort -V -u -r -k2 |
        sed -r 's/^(\w+)\s+(refs\/tags\/OTP-(([0-9]+).*))$/"\3":{"rev":"\1","ref":"\2","version":"\3","minor":"\4"}/' |
        paste -sd ','
    echo '}'
}

elixir_vers | jq > elixir-lock.json
erlang_vers | jq > erlang-lock.json
