# coding: utf-8
class Wiki

  include ActiveModel::Model

  validates :title, presence: true
  validate :changed_content

  attr_accessor :title, :content, :comment

  # XXX: missing required keys: [:id] 対策
  alias :id :title


  class << self
    def all
      Dir.glob("#{ExpandedPathname.root_pathname.to_s}/**/*.org").map do |f|
        t = ExpandedPathname.new(f).relative_path_from_root.to_s.sub(/\.org$/, '')
        self.new(title: t)
      end
    end

    def read(title)
      self.new(title: title)
    end
  end



  def initialize(attributes = {})
    super

    return unless attributes[:title]
    @pathname = ExpandedPathname.create(attributes[:title] + '.org')
  end

  def content
    @content ||= @pathname&.read
  end

  def exist?
    @pathname&.exist?
  end

  alias :persisted? :exist?

  def to_html
    Orgmode::Parser.new(content).to_html
  end

  def created_at
    @created_at ||= log.last.date unless log.size.zero?
  end

  def updated_at
    @updated_at ||= log.first.date unless log.size.zero?
  end

  def save
    # Validation 処理
    return false unless valid?

    # ディレクトリ・ファイル作成
    @pathname.dirname.mkpath
    @pathname.write(content)

    # git へコミット (プッシュ)
    GIT_REPO.add(@pathname.to_s)
    if @comment.empty?
      @comment = (log.size.zero?) ? "Create #{title}" : "Update #{title}"
    end
    GIT_REPO.commit(@comment)
    GIT_REPO.push if GIT_REPO.remote('origin').url

    true
  end

  def destroy
    # ファイル削除
    @pathname.delete

    # git へコミット (プッシュ)
    GIT_REPO.add(@pathname.to_s)
    GIT_REPO.commit("Delete #{title}")
    GIT_REPO.push if GIT_REPO.remote('origin').url
  end


  private

  def log
    GIT_REPO.log.path(@pathname.relative_path_from_root.to_s)
  end

  def changed_content
    if @pathname&.exist? and @content == @pathname.read
      errors.add(:content, "Content が変更されていません。")
    end
  end

end
