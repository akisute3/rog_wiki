# coding: utf-8

# Pathname のラッパー
class ExpandedPathname < Pathname

  ROOT_PATH = APP_CONFIG[:root_path]

  # root_path からの相対パスを引数に渡すと、
  # root_path に設定したディレクトリを root とした絶対パスを返す
  def self.create(path)
    self.new(path).expand_path(ROOT_PATH)
  end

  def self.root_pathname
    @root_pathname ||= self.new(ROOT_PATH).expand_path
  end

  def relative_path_from_root
    self.relative_path_from(self.class.root_pathname)
  end

end
