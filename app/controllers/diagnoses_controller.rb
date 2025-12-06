class DiagnosesController < ApplicationController
  def new
  end

  def result
    # 全質問まとめ（Q1〜Q11）
    answers = {
      q1_rank1: params[:q1_rank1],
      q1_rank2: params[:q1_rank2],
      q1_rank3: params[:q1_rank3],
      q1_rank4: params[:q1_rank4],
      q1_rank5: params[:q1_rank5],
      q2: params[:q2],
      q3: params[:q3],
      q4: params[:q4],
      q5: params[:q5],
      q6: params[:q6],
      q7: params[:q7],
      q8: params[:q8],
      q9: params[:q9],
      q10: params[:q10],
      q11: params[:q11]
    }

    # ① Q1（価値観）最優先で大枠の方向性を決める
    base_from_priority = priority_base_type(answers)

    # ② Q10（弾きたい曲）で方向性を“許容範囲で”強める
    after_song = adjust_by_song(base_from_priority, answers)

    # ③ Q6〜Q9（種類/ジャンル/音/スタイル）で細かく調整
    after_style = adjust_by_style(after_song, answers)

    # ④ Q11（メーカーの希望）で軽く補正
    final_code = adjust_by_brand(after_style, answers)

    @guitar_type = GuitarType.find_by(code: final_code)
    @guitar_type ||= GuitarType.find_by(code: "strat")
  end

  private

  ############################################
  # ① Q1 最優先で「方向性のベースタイプ」を決める
  ############################################
  def priority_base_type(a)
    pr = main_priority(a)

    case pr
    when :playability   # 弾きやすさ重視
      "strat"           # 軽くて扱いやすい
    when :price         # 価格重視
      "tele"            # コスパ高い
    when :design        # デザイン重視
      "jazzmaster"      # おしゃれ系
    when :sound         # 音重視
      "lp"              # 太い音を優先
    when :brand         # ブランド重視
      "strat"           # Fenderベースに寄せる
    else
      "strat"
    end
  end

  ############################################
  # Q1順位計算（あなたの元コードほぼそのまま）
  ############################################
  def main_priority(a)
    scores = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0 }
    ranks = [
      a[:q1_rank1].to_i,
      a[:q1_rank2].to_i,
      a[:q1_rank3].to_i,
      a[:q1_rank4].to_i,
      a[:q1_rank5].to_i
    ]

    ranks.each_with_index do |item, idx|
      next unless (1..5).include?(item)
      score = 5 - idx
      scores[item] += score
    end

    top_item, _ = scores.max_by { |_, v| v }

    { 1 => :playability, 2 => :price, 3 => :design, 4 => :sound, 5 => :brand }[top_item] || :sound
  end

  ############################################
  # ② Q10（曲）で方向性を強める
  ############################################
  def adjust_by_song(code, a)
    q10 = a[:q10].to_i

    song_type =
      case q10
      when 1 then "strat"
      when 2 then "tele"
      when 3 then "lp"
      when 4 then "sg"
      when 5 then "superstrat"
      when 6 then "metal_hh"
      when 7 then "semi"
      when 8 then "acoustic_fg"
      when 9 then "acoustic_fs"
      when 10 then "classical"
      end

    return code if song_type.nil?

    # Q1で決めた方向性と「近い場合だけ」更新する
    group = {
      strat: [ "strat", "tele", "jazzmaster", "superstrat" ],
      lp: [ "lp", "sg", "metal_hh" ],
      acoustic: [ "acoustic_fg", "acoustic_fs", "classical" ],
      semi: [ "semi" ]
    }

    group.each do |_, members|
      return song_type if members.include?(code) && members.include?(song_type)
    end

    code
  end

  ############################################
  # ③ Q6〜Q9（ジャンル・音・スタイル）で微調整
  ############################################
  def adjust_by_style(code, a)
    q4  = a[:q4].to_i
    q6  = a[:q6].to_i
    q8  = a[:q8].to_i
    q9  = a[:q9].to_i

    # エレキかアコギ
    if q6 == 1 # アコギ
      return "acoustic_fg" if q9 == 2
      return "acoustic_fs" if q9 == 1
      return code
    elsif q6 == 3 # エレアコ
      return "acoustic_fs" if q9 == 1
      return "acoustic_fg"
    end

    # エレキの分岐
    if q8 == 3 || q4 == 4
      return "metal_hh"
    end

    if q4 == 3
      return "semi"
    end

    if q9 == 1
      return (q8 == 4 ? "tele" : "strat")
    elsif q9 == 3
      return (q8 == 3 ? "lp" : "superstrat")
    end

    code
  end

  ############################################
  # ④ Q11（メーカー希望）で最終補正
  ############################################
  def adjust_by_brand(code, a)
    q11 = a[:q11].to_i

    case q11
    when 1 # Fender好き
      return "strat" if [ "tele", "jazzmaster", "superstrat" ].include?(code)
    when 2 # Gibson好き
      return "lp"     if [ "sg", "semi", "superstrat" ].include?(code)
    when 3 # Ibanez好き
      return "superstrat" if code == "strat"
    when 4 # Yamaha
      return code
    when 5 # Taylor（アコギ）
      return "acoustic_fg" if [ "acoustic_fg", "acoustic_fs" ].include?(code)
    end

    code
  end
end
