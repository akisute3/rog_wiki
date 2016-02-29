# coding: utf-8

# 設定ファイル読み込み
APP_CONFIG = HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/settings.yml"))

# Git リポジトリ作成
root_pathname = Pathname.new(APP_CONFIG[:root_path]).expand_path
root_pathname.mkpath
GIT_REPO = Git.init(root_pathname.to_s)

# user.name, user.email が登録されていなければ登録
GIT_REPO.config('user.name', 'RogWiki Default User') if GIT_REPO.config('user.name').empty?
GIT_REPO.config('user.email', 'rogwiki@email.com') if GIT_REPO.config('user.email').empty?

if APP_CONFIG[:remote_server] and GIT_REPO.remote('origin').url.nil?
  GIT_REPO.add_remote('origin', APP_CONFIG[:remote_server])
end

# 初回起動時には /home のページに README.org をコミット
begin
  GIT_REPO.log.size
rescue
  # README.org を root_path/home.org にコピーして最初のコミット (プッシュ) を行う
  FileUtils.copy(Rails.root.join('README.org').to_s, root_pathname.join('home.org'))
  GIT_REPO.add((root_pathname + 'home.org').to_s)
  GIT_REPO.commit('Create home')
  GIT_REPO.push if GIT_REPO.remote('origin').url
end
