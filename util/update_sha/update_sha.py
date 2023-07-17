import requests
import subprocess
import json

def release_props(owner, repo, rel):
    # remove 'v' from elixir
    # remove 'OTP-' from erlang
    version = rel[1:] if repo == 'elixir' else rel.replace('OTP-', '')

    # 1.15.0-rc.2 -> 1_15
    # 26.0.2 -> 26
    digits = 2 if repo == 'elixir' else 1
    minor = '_'.join(version.split('.')[:digits])

    prefetch_res = subprocess.run(['nix-prefetch-github', owner, repo, '--rev', rel], capture_output=True).stdout.decode('utf-8')
    prefetch = json.loads(prefetch_res)
    sha = prefetch['sha256']

    return {'version': version, 'minor': minor, 'sha256': sha}

def release_dict_for(owner, repo):
    releases = requests.get(f'https://api.github.com/repos/{owner}/{repo}/tags').json()
    tags = [rel["name"] for rel in releases]
    rel_props = [release_props(owner, repo, rel) for rel in tags]
    return {rel['version']: rel for rel in rel_props}


elixir = release_dict_for('elixir-lang', 'elixir')
with open('../../beam-lock/elixir.json', 'w') as elixir_json:
    json.dump(elixir, elixir_json)

erlang = release_dict_for('erlang', 'otp')
with open('../../beam-lock/erlang.json', 'w') as erlang_json:
    json.dump(erlang, erlang_json)
