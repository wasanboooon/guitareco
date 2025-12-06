# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# db/seeds.rb

# === 既存データの削除（外部キー順に） ===
TweetTagRelation.destroy_all
Tag.destroy_all
GuitarType.destroy_all


guitar_types = [
  {
    code: "strat",
    name: "ストラトキャスタータイプ",
    description: "3シングルコイルやHSS構成など、多くのバリエーションを持つ万能なエレキギターです。比較的軽量でバランスが良く、カッティングもソロもバッキングもこなせます。",
    recommended_styles: "ポップス／ロック／アニソン／オールジャンルで1本で何でもやりたい人向け。",
    low_price_model: "Squier Affinity Stratocaster",
    mid_price_model: "Squier Classic Vibe Stratocaster",
    high_price_model: "Fender Player Stratocaster",
    similar_type_code: "tele"
  },
  {
    code: "tele",
    name: "テレキャスタータイプ",
    description: "2シングルコイル構成で、シャキっと歯切れの良いサウンドが特徴のエレキギターです。構造がシンプルでトラブルが少なく、カッティングに強いです。",
    recommended_styles: "カッティング主体のポップス／ロック／カントリー／ファンクなど、リズム重視のプレイ。",
    low_price_model: "Squier Affinity Telecaster",
    mid_price_model: "Squier Classic Vibe Telecaster",
    high_price_model: "Fender Player Telecaster",
    similar_type_code: "strat"
  },
  {
    code: "lp",
    name: "レスポールタイプ",
    description: "2基のハムバッカーピックアップと厚いボディによる、太く甘いサウンドが特徴のエレキギターです。サスティンが長く、パワフルな歪みサウンドに向いています。",
    recommended_styles: "ロック／ハードロック／ブルースで、ギターソロを太く目立たせたい人。",
    low_price_model: "Epiphone Les Paul Studio / SL",
    mid_price_model: "Epiphone Les Paul Standard",
    high_price_model: "Gibson Les Paul Studio",
    similar_type_code: "sg"
  },
  {
    code: "sg",
    name: "SGタイプ",
    description: "レスポールよりも薄く軽いボディを持ち、ダブルカッタウェイで高音ポジションが弾きやすいエレキギターです。鋭く抜けの良いハムバッカーサウンドが特徴です。",
    recommended_styles: "ロック／ハードロックで、軽めのギターが欲しい人。高フレットを多用するソロにも向きます。",
    low_price_model: "Epiphone SG Special",
    mid_price_model: "Epiphone SG Standard",
    high_price_model: "Gibson SG Standard",
    similar_type_code: "lp"
  },
  {
    code: "superstrat",
    name: "スーパー・ストラト（ソロイスト／ディンキー系）",
    description: "ストラトシェイプをベースに、薄いネックや24フレット、高出力ハムバッカー、ロック式トレモロなどを搭載したモダンなエレキギターです。",
    recommended_styles: "メタル／ハードロック／フュージョンなど、速弾きやテクニカルなソロを多く弾きたい人。",
    low_price_model: "Ibanez GRGシリーズ / Jackson JS Dinky",
    mid_price_model: "Ibanez RG / Jackson X Series",
    high_price_model: "Ibanez Prestige / Jackson Pro Series",
    similar_type_code: "metal_hh"
  },
  {
    code: "jazzmaster",
    name: "ジャズマスタータイプ",
    description: "オフセットボディと独特のシングルコイル構成による、太く少し丸い高音を持つエレキギターです。元々ジャズ用として作られましたが、現在はオルタナやシューゲイザーで人気です。",
    recommended_styles: "オルタナ／インディーロック／シューゲイザーなど、少し個性のあるクリーン〜クランチサウンドを求める人。",
    low_price_model: "Squier Classic Vibe Jazzmaster",
    mid_price_model: "Fender Vintera Jazzmaster",
    high_price_model: "Fender American Performer Jazzmaster",
    similar_type_code: "mustang"
  },
  {
    code: "mustang",
    name: "ムスタングタイプ",
    description: "小ぶりなオフセットボディとショートスケールが特徴のエレキギターです。軽くて取り回しが良く、ラフなロックサウンドと相性が良いです。",
    recommended_styles: "オルタナ／ガレージロック／インディー系。手が小さめの人や、軽いギターが欲しい人にも向きます。",
    low_price_model: "Squier Bullet / Affinity Mustang",
    mid_price_model: "Fender Player Mustang",
    high_price_model: "Fender Vintera / American Performer Mustang",
    similar_type_code: "jazzmaster"
  },
  {
    code: "metal_hh",
    name: "メタル向けHH／多弦ギター",
    description: "2基のハムバッカーやアクティブピックアップ、高出力設計、7弦以上の多弦仕様など、ヘヴィなサウンドに特化したエレキギターです。",
    recommended_styles: "メタル／Djent／ヘヴィロックなど、低音リフと強い歪みを多用するスタイル。",
    low_price_model: "Ibanez GRG / Jackson JS Series 7弦",
    mid_price_model: "Ibanez RG / RGD, Schecter Omen / Demon シリーズ",
    high_price_model: "Ibanez Prestige / ESP・LTD 上位モデル",
    similar_type_code: "superstrat"
  },
  {
    code: "shapes",
    name: "変形ギター（フライングV／エクスプローラーなど）",
    description: "Vシェイプやエクスプローラーなど、ステージ映えする個性的なボディ形状のエレキギターです。ハムバッカー搭載のロック／メタル向きモデルが多いです。",
    recommended_styles: "ステージで目立ちたいロック／メタルギタリスト。立って弾くことが多い人に向きます。",
    low_price_model: "Epiphone Flying V / Explorer, Jackson JS King V",
    mid_price_model: "LTD Arrow / EX シリーズ",
    high_price_model: "Gibson Flying V / Explorer",
    similar_type_code: "metal_hh"
  },
  {
    code: "semi",
    name: "セミアコ（セミホロウ、ES-335タイプ）",
    description: "中央にセンターブロックを持ち、両側が空洞になっている構造のエレキギターです。フルアコよりハウリングに強く、太さと抜けのバランスが良いサウンドです。",
    recommended_styles: "ジャズ／ブルース／ソウル／オルタナなど、温かいクリーンから軽いクランチまでを多用する人。",
    low_price_model: "Ibanez Artcore セミアコモデル",
    mid_price_model: "Epiphone ES-335",
    high_price_model: "Gibson ES-335",
    similar_type_code: "full"
  },
  {
    code: "full",
    name: "フルアコ（フルアコースティックギター）",
    description: "中身がほぼ空洞の大きなボディを持つエレキギターです。生鳴りが豊かで、ジャズ向きのウォームなトーンが特徴ですが、強い歪みと大音量には弱くハウリングしやすいです。",
    recommended_styles: "ジャズ／スウィング／ビッグバンドなど、クリーン中心で落ち着いた音色を求める人。",
    low_price_model: "Ibanez Artcore フルアコモデル",
    mid_price_model: "Epiphone Emperor / Joe Pass モデル",
    high_price_model: "Gibson L-5 / ES-175系（かなり高価）",
    similar_type_code: "semi"
  },
  {
    code: "acoustic_fs",
    name: "アコースティックギター（小ぶりFSタイプ）",
    description: "ボディがやや小さめで抱えやすいアコースティックギターです。反応が速く、カッティングや軽めのストローク、アルペジオに向きます。",
    recommended_styles: "自宅やカフェなどでの小音量演奏、カッティングやアルペジオ中心のプレイ。手が小さめの人にも弾きやすいです。",
    low_price_model: "YAMAHA FS800 / FS820",
    mid_price_model: "YAMAHA FS830 / FSXシリーズ（ピックアップ付き）",
    high_price_model: "Taylor GS Mini / YAMAHA Aシリーズ小ぶりモデル",
    similar_type_code: "acoustic_mini"
  },
  {
    code: "acoustic_fg",
    name: "アコースティックギター（大きめFGタイプ）",
    description: "ドレッドノートサイズなどの大きめボディを持つアコースティックギターです。音量が出やすく、ストロークの迫力と低音の厚みが特徴です。",
    recommended_styles: "弾き語りで歌をしっかり支えたい人、ストローク中心でジャカジャカ弾きたい人、バンドやサークルでアコギを使いたい人。",
    low_price_model: "YAMAHA F310 / FG800",
    mid_price_model: "YAMAHA FG820 / FG830",
    high_price_model: "YAMAHA FGXシリーズ / Takamine エレアコモデル",
    similar_type_code: "acoustic_fs"
  },
  {
    code: "acoustic_mini",
    name: "ミニアコースティックギター（トラベルギター）",
    description: "全体的に小さめのボディとスケールを持つアコースティックギターです。持ち運びしやすく、家や旅行先、アウトドアで気軽に弾けます。",
    recommended_styles: "ソファやベッドでのちょっとした練習、作曲用、持ち運び重視の人。子どもや小柄な人の最初の1本としても人気です。",
    low_price_model: "S.Yairi YM-02 など",
    mid_price_model: "YAMAHA JRシリーズ",
    high_price_model: "Taylor GS Mini / Baby Taylor",
    similar_type_code: "acoustic_fs"
  },
  {
    code: "classical",
    name: "クラシックギター（ナイロン弦）",
    description: "ナイロン弦を使用し、指に優しく温かく柔らかい音色が特徴のギターです。指弾きのアルペジオやクラシック、ボサノバなどに向きます。",
    recommended_styles: "クラシック／ボサノバ／映画音楽など、落ち着いた曲を指弾きで演奏したい人。スチール弦の硬さが苦手な人にも向きます。",
    low_price_model: "YAMAHA C40",
    mid_price_model: "YAMAHA CGシリーズ / Cordoba C3M",
    high_price_model: "Cordoba C5/C7, YAMAHA GCシリーズ",
    similar_type_code: "acoustic_fg"
  },
  {
    code: "headless",
    name: "ヘッドレスギター",
    description: "ヘッド部分がなく、コンパクトで軽量なエレキギターです。バランスが良く、現代的なデザインとプレイアビリティを持ちます。",
    recommended_styles: "モダンロック／フュージョン／Djentなど、テクニカルなプレイや取り回しの良さを重視する人。自宅・スタジオ・ライブなど様々な場面で使いたい人向け。",
    low_price_model: "入門〜中価格帯のヘッドレス入門モデル（例：安価なHeadlessコピー系）",
    mid_price_model: "Sterling by Music Man のヘッドレスモデルなど",
    high_price_model: "Strandberg Bodenシリーズ など",
    similar_type_code: "superstrat"
  }
]



guitar_types.each do |attrs|
  GuitarType.create!(attrs)
end

GuitarType.find_each do |gt|
  Tag.find_or_create_by!(
    name: gt.name,
    category: Tag::CATEGORY_GUITAR_TYPE
  )
end

price_tags = [
  "〜1万円",
  "1〜3万円",
  "3〜5万円",
  "5〜8万円",
  "8〜12万円",
  "12〜20万円",
  "20〜40万円",
  "40万円〜"
]

price_tags.each do |name|
  Tag.find_or_create_by!(
    name: name,
    category: Tag::CATEGORY_PRICE   # ← ここも重要！
  )
end

maker_tags = [
  "Fender", "Squier", "Gibson", "Epiphone",
  "Yamaha", "Ibanez", "ESP", "PRS",
  "Taylor", "Martin", "Takamine",
  "Schecter", "Jackson", "Music Man",
  "Strandberg"
]

maker_tags.each do |name|
  Tag.find_or_create_by!(
    name: name,
    category: Tag::CATEGORY_MAKER
  )
end





puts "GuitarType: #{GuitarType.count}件作成しました"
