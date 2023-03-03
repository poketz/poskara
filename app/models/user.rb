class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :forum_comments, dependent: :destroy
  has_many :forum_favorites, dependent: :destroy

  enum gender: { male: 0, female: 1, other: 2 }
  enum prefecture: {
    please_select:0,
    hokkaido:1, aomori:2, iwate:3, miyagi:4, akita:5,yamagata:6,fukushima:7,
    ibaraki:8, tochigi:9, gunma:10, saitama:11, chiba:12, tokyo:13, kanagawa:14,
    niigata:15, toyama:16, ishikawa:17, fukui:18, yamanashi:19, nagano:20,
    gifu:21, shizuoka:22, aichi:23, mie:24,
    shiga:25, kyoto:26, osaka:27, hyogo:28, nara:29, wakayama:30,
    tottori:31, shimane:32, okayama:33, hiroshima:34, yamaguchi:35,
    tokushima:36, kagawa:37, ehime:38, kochi:39,
    fukuoka:40, saga:41, nagasaki:42, kumamoto:43, oita:44, miyazaki:45, kagoshima:46,
    okinawa:47
  }

  has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def self.search(search, word)
    # キーワード検索からユーザーを特定
    if search == "perfect_match"
      User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      User.where("name LIKE?","%#{word}%")
    else
      User.all
    end
  end
end
