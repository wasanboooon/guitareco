class TweetsController < ApplicationController
  before_action :authenticate_user!

  def index
    # ユーザーとタグをまとめて読み込んで N+1 を防ぐ
    @tweets = Tweet.includes(:tags, :user)

    search = params[:search]
    @tweets = @tweets.joins(:user).where("body LIKE ?", "%#{search}%") if search.present?

    # チェックボックスのタグ絞り込み
    if params[:tag_ids].present?
      selected_tag_names =
        params[:tag_ids].select { |_name, v| v == "1" }.keys

      if selected_tag_names.any?
        @tweets = @tweets.joins(:tags)
                         .where(tags: { name: selected_tag_names })
                         .distinct
      end
    end

    # 絞り込みフォームで使うタグをカテゴリ別に用意
    @guitar_type_tags = Tag.guitar_type
    @price_tags       = Tag.price
    @maker_tags       = Tag.maker
  end

  def new
    @tweet = Tweet.new
    @guitar_type_tags = Tag.guitar_type
    @price_tags       = Tag.price
    @maker_tags       = Tag.maker
  end

  def create
    # ログインユーザーに紐づく Tweet
    @tweet = current_user.tweets.new(tweet_params)

    # チェックボックスの tag_ids を紐づけ
    if params[:tweet][:tag_ids]
      ids = params[:tweet][:tag_ids].reject(&:blank?)
      @tweet.tags = Tag.where(id: ids)
    end

    # メーカー自由入力 → メーカータグに変換して追加
    if params[:maker_names].present?
      maker_names = params[:maker_names].split(/[、,]/).map(&:strip).reject(&:blank?)

      maker_tags = maker_names.map do |name|
        Tag.find_or_create_by!(
          name:     name,
          category: Tag::CATEGORY_MAKER
        )
      end

      # 既存タグ + メーカータグ を重複なしで代入
      @tweet.tags = (@tweet.tags + maker_tags).uniq
    end

    if @tweet.save
      redirect_to tweets_path, notice: "Tweetを投稿しました"
    else
      @guitar_type_tags = Tag.guitar_type
      @price_tags       = Tag.price
      @maker_tags       = Tag.maker
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @tweet = Tweet.find(params[:id])
  end

  def edit
    @tweet = Tweet.find(params[:id])
    @guitar_type_tags = Tag.guitar_type
    @price_tags       = Tag.price
    @maker_tags       = Tag.maker
  end

  def update
    @tweet = Tweet.find(params[:id])

    # チェックボックスのタグを反映
    if params[:tweet][:tag_ids]
      ids = params[:tweet][:tag_ids].reject(&:blank?)
      @tweet.tags = Tag.where(id: ids)
    else
      @tweet.tags = []
    end

    # メーカー自由入力 → タグ化
    if params[:maker_names].present?
      maker_names = params[:maker_names].split(/[、,]/).map(&:strip).reject(&:blank?)

      maker_tags = maker_names.map do |name|
        Tag.find_or_create_by!(
          name:     name,
          category: Tag::CATEGORY_MAKER
        )
      end

      @tweet.tags = (@tweet.tags + maker_tags).uniq
    end

    if @tweet.update(tweet_params)
      redirect_to tweets_path, notice: "Tweetを更新しました"
    else
      @guitar_type_tags = Tag.guitar_type
      @price_tags       = Tag.price
      @maker_tags       = Tag.maker
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to tweets_path
  end

  private

  def tweet_params
    params.require(:tweet).permit(:body, :image, tag_ids: [])
  end
end
