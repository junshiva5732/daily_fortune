/// 운세 문구 데이터 (ko / en / ja / zh).
///
/// 운세 생성은 "인덱스"로 뽑기 때문에, 언어가 달라도 같은 날 같은 사람은
/// 같은 인덱스의 문구를 받는다. 따라서 모든 언어의 목록 길이는 반드시 같아야 한다
/// (하나의 [FortuneLine] 이 4개 언어를 함께 갖는 구조로 강제).
///
/// 점수 분포: 5점·4점·3점을 넉넉히, 2점·1점은 적게.
library;

/// 4개 언어 텍스트.
class T {
  final String ko;
  final String en;
  final String ja;
  final String zh;
  const T(this.ko, this.en, this.ja, this.zh);

  String of(String lang) => switch (lang) {
        'ko' => ko,
        'ja' => ja,
        'zh' => zh,
        _ => en,
      };
}

class FortuneLine {
  final int score; // 1(주의) ~ 5(최고)
  final T text;
  const FortuneLine(this.score, this.text);
}

enum Category { overall, love, money, work, health }

class FortuneData {
  FortuneData._();

  /// 지원 언어. 이 외의 시스템 언어는 영어로 폴백.
  static const supportedLangs = ['ko', 'en', 'ja', 'zh'];

  static const zodiacAnimals = [
    T('쥐', 'Rat', 'ねずみ', '鼠'),
    T('소', 'Ox', 'うし', '牛'),
    T('호랑이', 'Tiger', 'とら', '虎'),
    T('토끼', 'Rabbit', 'うさぎ', '兔'),
    T('용', 'Dragon', 'たつ', '龙'),
    T('뱀', 'Snake', 'へび', '蛇'),
    T('말', 'Horse', 'うま', '马'),
    T('양', 'Goat', 'ひつじ', '羊'),
    T('원숭이', 'Monkey', 'さる', '猴'),
    T('닭', 'Rooster', 'とり', '鸡'),
    T('개', 'Dog', 'いぬ', '狗'),
    T('돼지', 'Pig', 'いのしし', '猪'),
  ];

  static const zodiacEmoji = [
    '🐭', '🐮', '🐯', '🐰', '🐲', '🐍',
    '🐴', '🐑', '🐵', '🐔', '🐶', '🐷',
  ];

  /// 출생 연도로 띠 인덱스 계산. 1900년 = 쥐띠 기준.
  static int zodiacIndex(int year) => ((year - 1900) % 12 + 12) % 12;

  static const luckyColors = [
    T('빨강', 'Red', '赤', '红色'),
    T('주황', 'Orange', 'オレンジ', '橙色'),
    T('노랑', 'Yellow', '黄色', '黄色'),
    T('초록', 'Green', '緑', '绿色'),
    T('파랑', 'Blue', '青', '蓝色'),
    T('남색', 'Indigo', '藍色', '靛蓝'),
    T('보라', 'Purple', '紫', '紫色'),
    T('흰색', 'White', '白', '白色'),
    T('검정', 'Black', '黒', '黑色'),
    T('금색', 'Gold', 'ゴールド', '金色'),
    T('은색', 'Silver', 'シルバー', '银色'),
    T('분홍', 'Pink', 'ピンク', '粉色'),
    T('하늘색', 'Sky blue', '水色', '天蓝色'),
    T('갈색', 'Brown', '茶色', '棕色'),
    T('민트', 'Mint', 'ミント', '薄荷绿'),
    T('라벤더', 'Lavender', 'ラベンダー', '薰衣草紫'),
    T('와인색', 'Wine red', 'ワインレッド', '酒红色'),
    T('베이지', 'Beige', 'ベージュ', '米色'),
    T('카키', 'Khaki', 'カーキ', '卡其色'),
    T('네이비', 'Navy', 'ネイビー', '藏青色'),
  ];

  static const luckyItems = [
    T('손수건', 'Handkerchief', 'ハンカチ', '手帕'),
    T('동전', 'Coin', 'コイン', '硬币'),
    T('펜', 'Pen', 'ペン', '钢笔'),
    T('열쇠고리', 'Keychain', 'キーホルダー', '钥匙扣'),
    T('작은 식물', 'Small plant', '小さな植物', '小盆栽'),
    T('책', 'Book', '本', '书'),
    T('머그컵', 'Mug', 'マグカップ', '马克杯'),
    T('스카프', 'Scarf', 'スカーフ', '围巾'),
    T('시계', 'Watch', '時計', '手表'),
    T('향초', 'Scented candle', 'アロマキャンドル', '香薰蜡烛'),
    T('사진', 'Photo', '写真', '照片'),
    T('엽서', 'Postcard', 'ポストカード', '明信片'),
    T('반지', 'Ring', '指輪', '戒指'),
    T('이어폰', 'Earphones', 'イヤホン', '耳机'),
    T('우산', 'Umbrella', '傘', '雨伞'),
    T('노트', 'Notebook', 'ノート', '笔记本'),
    T('텀블러', 'Tumbler', 'タンブラー', '保温杯'),
    T('모자', 'Hat', '帽子', '帽子'),
    T('립밤', 'Lip balm', 'リップクリーム', '润唇膏'),
    T('팔찌', 'Bracelet', 'ブレスレット', '手链'),
    T('스티커', 'Sticker', 'ステッカー', '贴纸'),
    T('초콜릿', 'Chocolate', 'チョコレート', '巧克力'),
    T('사탕', 'Candy', 'キャンディ', '糖果'),
    T('커피', 'Coffee', 'コーヒー', '咖啡'),
    T('녹차', 'Green tea', '緑茶', '绿茶'),
    T('꽃 한 송이', 'A single flower', '一輪の花', '一枝花'),
    T('지갑', 'Wallet', '財布', '钱包'),
    T('거울', 'Mirror', '鏡', '镜子'),
  ];

  static const luckyDirections = [
    T('동쪽', 'East', '東', '东'),
    T('서쪽', 'West', '西', '西'),
    T('남쪽', 'South', '南', '南'),
    T('북쪽', 'North', '北', '北'),
    T('동남쪽', 'Southeast', '南東', '东南'),
    T('서북쪽', 'Northwest', '北西', '西北'),
    T('동북쪽', 'Northeast', '北東', '东北'),
    T('서남쪽', 'Southwest', '南西', '西南'),
  ];

  static const Map<Category, List<FortuneLine>> lines = {
    // ═══════════════════════════════════════════════════════════════ 총운
    Category.overall: [
      FortuneLine(5, T(
        '기다리던 소식이 도착하는 날입니다. 오늘 내리는 결정은 오래도록 좋은 결과를 가져옵니다.',
        'News you have been waiting for arrives today. Decisions made now will pay off for a long time.',
        '待っていた知らせが届く日です。今日の決断は長く良い結果をもたらします。',
        '期待已久的消息今天到来。今天做的决定会带来长久的好结果。')),
      FortuneLine(5, T(
        '평소보다 운이 크게 트이는 날. 미뤄두었던 일을 오늘 시작하면 순조롭게 풀립니다.',
        'Luck opens wide today. Start something you have been putting off and it will go smoothly.',
        'いつもより運が大きく開ける日。先延ばしにしていたことを今日始めると順調に進みます。',
        '今天运气大开。把之前搁置的事情今天开始做，会进展顺利。')),
      FortuneLine(5, T(
        '하늘이 돕는 하루입니다. 어렵다고 생각했던 일이 뜻밖에 쉽게 풀립니다.',
        'The heavens are on your side. Something you thought was hard turns out surprisingly easy.',
        '天が味方する一日です。難しいと思っていたことが意外なほど簡単に片付きます。',
        '今天有贵人相助。原以为困难的事情出乎意料地顺利解决。')),
      FortuneLine(5, T(
        '귀인이 나타나는 날. 오늘 만나는 사람과의 인연을 소중히 하세요.',
        'A helpful person appears today. Treasure the people you meet.',
        '貴人が現れる日。今日出会う人との縁を大切にしましょう。',
        '今天会遇到贵人。珍惜今天结识的每一份缘分。')),
      FortuneLine(5, T(
        '오래 준비한 것이 빛을 보는 날입니다. 자신을 믿고 앞으로 나아가세요.',
        'What you prepared for so long finally shines. Trust yourself and move forward.',
        '長く準備してきたことが実を結ぶ日。自分を信じて前に進みましょう。',
        '长期的准备今天终见成果。相信自己，勇往直前。')),
      FortuneLine(5, T(
        '모든 일이 물 흐르듯 흘러갑니다. 오늘은 큰 결정을 내리기에 최적의 날입니다.',
        'Everything flows like water. Today is ideal for making a big decision.',
        'すべてが水の流れのように進みます。大きな決断をするのに最適な日です。',
        '一切顺水推舟。今天是做重大决定的最佳时机。')),
      FortuneLine(5, T(
        '행운이 연달아 찾아오는 날. 작은 기회도 놓치지 말고 잡으세요.',
        'Luck keeps arriving one after another. Grab even the smallest opportunity.',
        '幸運が次々と訪れる日。小さなチャンスも逃さずつかみましょう。',
        '好运接踵而至。再小的机会也别错过。')),
      FortuneLine(4, T(
        '주변 사람의 도움으로 막혔던 일이 풀립니다. 감사의 말을 아끼지 마세요.',
        'A stuck situation clears up thanks to someone near you. Do not hold back your thanks.',
        '周りの人の助けで行き詰まっていたことが解決します。感謝の言葉を惜しまないで。',
        '在身边人的帮助下，僵局得以化解。别吝啬你的感谢。')),
      FortuneLine(4, T(
        '작은 행운이 이어지는 하루. 평소 지나치던 곳에서 뜻밖의 기회를 발견합니다.',
        'Small strokes of luck all day long. You spot an opportunity somewhere you usually pass by.',
        '小さな幸運が続く一日。いつも通り過ぎていた場所で思わぬチャンスを見つけます。',
        '小幸运接连不断。在平时忽略的地方发现意外的机会。')),
      FortuneLine(4, T(
        '자신감이 넘치는 날입니다. 망설이던 제안을 오늘 꺼내보세요.',
        'Confidence is overflowing. Bring up that proposal you have been hesitating about.',
        '自信に満ちた日です。ためらっていた提案を今日切り出してみましょう。',
        '今天充满自信。把犹豫已久的提议说出来吧。')),
      FortuneLine(4, T(
        '노력한 만큼 돌아오는 정직한 하루. 성실함이 인정받습니다.',
        'An honest day where effort is returned in kind. Your diligence gets recognized.',
        '努力した分だけ返ってくる正直な一日。誠実さが認められます。',
        '付出多少收获多少的诚实一天。你的勤恳会得到认可。')),
      FortuneLine(4, T(
        '기분 좋은 우연이 따르는 날. 계획에 없던 일정도 즐겁게 받아들이세요.',
        'Pleasant coincidences follow you. Welcome plans that were not on the schedule.',
        '心地よい偶然が続く日。予定になかったことも楽しんで受け入れましょう。',
        '今天充满愉快的巧合。计划外的安排也欣然接受吧。')),
      FortuneLine(4, T(
        '주변의 분위기가 당신 편입니다. 부탁할 일이 있다면 오늘 하세요.',
        'The mood around you is on your side. If you need a favor, ask today.',
        '周りの雰囲気があなたの味方です。頼みごとがあるなら今日のうちに。',
        '周围的氛围站在你这边。有事相求就趁今天。')),
      FortuneLine(4, T(
        '새로운 시작에 좋은 기운이 흐릅니다. 첫걸음을 떼기에 좋은 날입니다.',
        'Good energy flows toward new beginnings. A fine day to take the first step.',
        '新しい始まりに良い気が流れています。第一歩を踏み出すのに良い日です。',
        '新的开始有好运加持。今天适合迈出第一步。')),
      FortuneLine(4, T(
        '어제의 고민이 오늘은 가볍게 느껴집니다. 마음의 여유가 좋은 판단을 부릅니다.',
        'Yesterday\'s worries feel lighter today. A relaxed mind leads to good judgment.',
        '昨日の悩みが今日は軽く感じられます。心の余裕が良い判断を呼びます。',
        '昨天的烦恼今天变得轻松。从容的心态带来正确的判断。')),
      FortuneLine(3, T(
        '큰 변화 없이 잔잔하게 흘러가는 하루. 루틴을 지키는 것이 최선입니다.',
        'A calm day without big changes. Sticking to your routine is the best move.',
        '大きな変化のない穏やかな一日。ルーティンを守るのが一番です。',
        '平静无波的一天。坚持日常节奏是最好的选择。')),
      FortuneLine(3, T(
        '오전엔 더디지만 오후부터 흐름이 좋아집니다. 중요한 일은 오후로 잡으세요.',
        'Slow in the morning, but the flow improves after noon. Schedule important things for the afternoon.',
        '午前はゆっくりですが午後から流れが良くなります。大事なことは午後に。',
        '上午进展缓慢，下午渐入佳境。重要的事安排在下午。')),
      FortuneLine(3, T(
        '무리한 계획보다 한 가지에 집중할 때 성과가 납니다.',
        'Focusing on one thing beats an overambitious plan today.',
        '無理な計画より一つに集中する方が成果につながります。',
        '与其贪多，不如专注一件事更有成效。')),
      FortuneLine(3, T(
        '평범한 하루지만 작은 친절이 큰 인상을 남깁니다. 먼저 인사를 건네보세요.',
        'An ordinary day, but a small kindness leaves a big impression. Say hello first.',
        '平凡な一日ですが、小さな親切が大きな印象を残します。先に挨拶してみましょう。',
        '平凡的一天，但一个小小的善举会留下深刻印象。主动打个招呼吧。')),
      FortuneLine(3, T(
        '기다림이 필요한 날. 조급해하지 않으면 흐름은 자연스럽게 좋아집니다.',
        'A day that calls for patience. Do not rush and the flow will improve on its own.',
        '待つことが必要な日。焦らなければ流れは自然に良くなります。',
        '今天需要耐心。不急不躁，局面自然会好转。')),
      FortuneLine(3, T(
        '생각이 많아지는 하루. 산책이나 가벼운 운동이 머리를 맑게 합니다.',
        'A day full of thoughts. A walk or light exercise will clear your head.',
        '考えごとが多くなる一日。散歩や軽い運動で頭がすっきりします。',
        '思绪纷繁的一天。散步或轻度运动能让头脑清醒。')),
      FortuneLine(3, T(
        '남의 일에 참견하기보다 내 일에 집중할 때 하루가 편안합니다.',
        'The day goes easier when you focus on your own business rather than others\'.',
        '他人のことに口を出すより自分のことに集中すると穏やかな一日になります。',
        '少管闲事，专注自己的事，一天会过得更安稳。')),
      FortuneLine(3, T(
        '준비한 만큼만 결과가 나오는 날. 요행을 바라기보다 기본을 지키세요.',
        'You get exactly what you prepared for. Stick to the basics instead of hoping for luck.',
        '準備した分だけ結果が出る日。幸運を期待するより基本を守りましょう。',
        '准备多少就收获多少的一天。与其侥幸，不如守住基本功。')),
      FortuneLine(3, T(
        '오늘은 듣는 사람이 되어보세요. 뜻밖의 정보가 귀에 들어옵니다.',
        'Be the listener today. Unexpected information comes your way.',
        '今日は聞き役に回ってみましょう。思わぬ情報が耳に入ります。',
        '今天做个倾听者。意想不到的信息会传入耳中。')),
      FortuneLine(3, T(
        '늦은 오후에 반가운 연락이 올 수 있습니다. 휴대폰을 가까이 두세요.',
        'A welcome message may arrive late in the afternoon. Keep your phone close.',
        '夕方に嬉しい連絡が来るかもしれません。スマホを近くに置いておきましょう。',
        '傍晚可能收到令人高兴的消息。把手机放在身边。')),
      FortuneLine(2, T(
        '사소한 오해가 생기기 쉬운 날. 말을 한 번 더 생각하고 꺼내세요.',
        'Small misunderstandings come easily today. Think twice before you speak.',
        'ちょっとした誤解が生まれやすい日。言葉はもう一度考えてから口にしましょう。',
        '今天容易产生小误会。说话前多想一想。')),
      FortuneLine(2, T(
        '서두르면 실수가 따릅니다. 오늘은 확인을 두 번 하는 습관이 필요합니다.',
        'Haste brings mistakes. Make a habit of double-checking today.',
        '急ぐとミスが伴います。今日は二度確認する習慣が必要です。',
        '欲速则不达。今天养成反复确认的习惯。')),
      FortuneLine(2, T(
        '계획이 어긋나기 쉬운 하루. 여유 시간을 넉넉히 잡아두세요.',
        'Plans go off track easily today. Leave plenty of buffer time.',
        '予定が狂いやすい一日。余裕を持ったスケジュールにしましょう。',
        '计划容易被打乱的一天。多留一些机动时间。')),
      FortuneLine(2, T(
        '주변 소음에 마음이 흔들릴 수 있습니다. 내 기준을 지키세요.',
        'Noise around you may shake your mind. Hold on to your own standards.',
        '周りの雑音に心が揺れるかもしれません。自分の基準を守りましょう。',
        '周围的杂音可能让你动摇。坚守自己的原则。')),
      FortuneLine(2, T(
        '작은 손해가 생길 수 있는 날. 물건을 잃어버리지 않도록 챙기세요.',
        'A small loss is possible today. Keep an eye on your belongings.',
        '小さな損をするかもしれない日。持ち物をなくさないように気をつけて。',
        '今天可能有小损失。看好自己的物品。')),
      FortuneLine(1, T(
        '뜻대로 되지 않는 일이 많을 수 있습니다. 새로운 시도보다는 정리에 집중하세요.',
        'Many things may not go your way. Focus on tidying up rather than starting anew.',
        '思い通りにいかないことが多いかもしれません。新しい試みより整理に集中しましょう。',
        '今天可能诸事不顺。与其尝试新事物，不如专心整理。')),
      FortuneLine(1, T(
        '감정 기복이 큰 하루. 중요한 결정은 내일로 미루는 것이 현명합니다.',
        'An emotionally bumpy day. It is wise to postpone important decisions until tomorrow.',
        '感情の起伏が大きい一日。大事な決断は明日に回すのが賢明です。',
        '情绪起伏较大的一天。重要决定最好推到明天。')),
      FortuneLine(1, T(
        '오늘은 한 걸음 물러서는 날. 무리하지 않으면 내일이 훨씬 가볍습니다.',
        'A day to step back. Do not push yourself and tomorrow will feel much lighter.',
        '今日は一歩引く日。無理をしなければ明日はずっと楽になります。',
        '今天适合退一步。不勉强自己，明天会轻松许多。')),
    ],

    // ═══════════════════════════════════════════════════════════════ 애정운
    Category.love: [
      FortuneLine(5, T(
        '설레는 만남이 찾아옵니다. 솔로라면 모임에 나가보고, 커플이라면 마음을 표현하세요.',
        'An exciting encounter is coming. If single, go out and meet people; if taken, express your feelings.',
        'ときめく出会いが訪れます。独り身なら集まりに出かけ、カップルなら気持ちを伝えましょう。',
        '心动的邂逅即将到来。单身就去参加聚会，有伴就大胆表达心意。')),
      FortuneLine(5, T(
        '상대의 마음이 활짝 열리는 날. 오래 하고 싶었던 말을 오늘 전하면 통합니다.',
        'Their heart opens wide today. Say what you have long wanted to say and it will get through.',
        '相手の心が大きく開く日。ずっと言いたかったことを今日伝えれば届きます。',
        '对方今天敞开心扉。把一直想说的话说出来，一定能传达到。')),
      FortuneLine(5, T(
        '사랑이 깊어지는 하루. 함께 보내는 시간이 오래 기억에 남을 것입니다.',
        'Love deepens today. Time spent together will be remembered for a long time.',
        '愛が深まる一日。一緒に過ごす時間が長く記憶に残るでしょう。',
        '爱意加深的一天。共度的时光将成为长久的回忆。')),
      FortuneLine(5, T(
        '첫눈에 통하는 인연이 가까이 있습니다. 눈길이 머무는 사람을 기억해두세요.',
        'A connection that clicks at first sight is near. Remember the person your eyes linger on.',
        '一目で通じ合う縁がすぐそばに。目が留まる人を覚えておきましょう。',
        '一见如故的缘分就在身边。记住那个让你目光停留的人。')),
      FortuneLine(5, T(
        '고백이나 프러포즈에 최고의 날. 진심은 반드시 전해집니다.',
        'The best day for a confession or proposal. Sincerity will surely get through.',
        '告白やプロポーズに最高の日。真心は必ず伝わります。',
        '表白或求婚的最佳日子。真心一定会被感受到。')),
      FortuneLine(5, T(
        '오해가 풀리고 관계가 회복되는 날. 먼저 손을 내밀면 상대도 응답합니다.',
        'Misunderstandings clear and the relationship heals. Reach out first and they will respond.',
        '誤解が解けて関係が回復する日。先に手を差し伸べれば相手も応えてくれます。',
        '误会化解、关系修复的一天。主动伸出手，对方也会回应。')),
      FortuneLine(4, T(
        '따뜻한 대화가 관계를 한 단계 깊게 만듭니다. 먼저 연락해보세요.',
        'A warm conversation takes the relationship a step deeper. Reach out first.',
        '温かい会話が関係を一段深めます。先に連絡してみましょう。',
        '温暖的对话让关系更进一步。主动联系吧。')),
      FortuneLine(4, T(
        '작은 배려가 큰 감동으로 돌아옵니다. 상대가 좋아하는 것을 기억해두세요.',
        'A small act of care returns as a big touch of the heart. Remember what they like.',
        '小さな気遣いが大きな感動になって返ってきます。相手の好きなものを覚えておいて。',
        '小小的体贴会换来大大的感动。记住对方的喜好。')),
      FortuneLine(4, T(
        '함께 웃을 일이 많은 하루. 유머가 관계의 윤활유가 됩니다.',
        'Plenty to laugh about together today. Humor is the lubricant of your relationship.',
        '一緒に笑うことが多い一日。ユーモアが関係の潤滑油になります。',
        '今天有很多一起欢笑的时刻。幽默是关系的润滑剂。')),
      FortuneLine(4, T(
        '누군가 당신을 눈여겨보고 있습니다. 평소보다 밝게 웃어보세요.',
        'Someone has their eye on you. Smile a little brighter than usual.',
        '誰かがあなたに注目しています。いつもより明るく笑ってみましょう。',
        '有人正在悄悄关注你。比平时笑得更灿烂些吧。')),
      FortuneLine(4, T(
        '오래된 친구가 특별한 인연으로 바뀔 수 있는 날입니다.',
        'An old friend could turn into something special today.',
        '古い友人が特別な縁に変わるかもしれない日です。',
        '老朋友今天可能变成特别的缘分。')),
      FortuneLine(4, T(
        '데이트 계획을 세우기 좋은 날. 새로운 장소가 새로운 설렘을 줍니다.',
        'A good day to plan a date. A new place brings new excitement.',
        'デートの計画を立てるのに良い日。新しい場所が新しいときめきをくれます。',
        '适合计划约会的一天。新地点带来新心动。')),
      FortuneLine(4, T(
        '상대의 작은 변화를 알아채주세요. 그 한마디가 하루를 바꿉니다.',
        'Notice the small changes in your partner. That one remark changes their whole day.',
        '相手の小さな変化に気づいてあげて。その一言が一日を変えます。',
        '留意对方的细微变化。一句话就能改变他的一天。')),
      FortuneLine(4, T(
        '주변에서 좋은 사람을 소개받을 수 있습니다. 열린 마음으로 만나보세요.',
        'Someone may introduce you to a good person. Meet them with an open mind.',
        '周りから良い人を紹介してもらえるかも。心を開いて会ってみましょう。',
        '身边的人可能为你介绍好对象。敞开心扉去见见吧。')),
      FortuneLine(3, T(
        '무난한 하루. 특별한 이벤트보다 함께 보내는 평범한 시간이 소중합니다.',
        'An uneventful day. Ordinary time together matters more than a special event.',
        '無難な一日。特別なイベントより一緒に過ごす平凡な時間が大切です。',
        '平淡的一天。比起特别的活动，平凡的相处时光更珍贵。')),
      FortuneLine(3, T(
        '상대의 이야기를 들어주는 데 집중하세요. 말보다 경청이 힘을 발휘합니다.',
        'Focus on listening. Hearing them out works better than talking.',
        '相手の話を聞くことに集中しましょう。言葉より傾聴が力を発揮します。',
        '专心倾听对方。倾听比言语更有力量。')),
      FortuneLine(3, T(
        '연락이 뜸하더라도 조급해하지 마세요. 상대도 바쁜 시기입니다.',
        'Do not fret if messages are sparse. They are going through a busy time too.',
        '連絡が少なくても焦らないで。相手も忙しい時期です。',
        '联系少了也别着急。对方也正忙。')),
      FortuneLine(3, T(
        '혼자만의 시간이 필요한 날. 자신을 돌보는 것이 곧 관계를 돌보는 일입니다.',
        'A day that calls for time alone. Caring for yourself is caring for the relationship.',
        '一人の時間が必要な日。自分を大切にすることが関係を大切にすることです。',
        '需要独处的一天。照顾好自己就是照顾好关系。')),
      FortuneLine(3, T(
        '관계에 큰 변화는 없지만 안정감이 있는 하루. 감사한 마음을 표현하세요.',
        'No big changes, but a stable day for the relationship. Express your gratitude.',
        '関係に大きな変化はないけれど安定感のある一日。感謝の気持ちを伝えましょう。',
        '关系没有大变化，但很安稳。表达一下感谢吧。')),
      FortuneLine(3, T(
        '기대보다 현실을 보는 날. 있는 그대로의 상대를 받아들이면 편안해집니다.',
        'See reality rather than expectations today. Accepting them as they are brings peace.',
        '期待より現実を見る日。ありのままの相手を受け入れると楽になります。',
        '今天看清现实而非期待。接受对方本来的样子会更轻松。')),
      FortuneLine(3, T(
        '가벼운 안부 인사가 관계를 유지하는 힘이 됩니다. 짧게라도 연락하세요.',
        'A light hello keeps the relationship alive. Send even a short message.',
        '軽い挨拶が関係を保つ力になります。短くても連絡しましょう。',
        '简单的问候是维系关系的力量。哪怕一句话也联系一下。')),
      FortuneLine(3, T(
        '솔로라면 자기계발에 집중하기 좋은 날. 매력은 스스로 만드는 것입니다.',
        'If single, a good day to invest in yourself. Charm is something you build.',
        '独り身なら自分磨きに集中するのに良い日。魅力は自分で作るものです。',
        '单身的话，适合专注自我提升。魅力是自己创造的。')),
      FortuneLine(3, T(
        '상대의 사정을 먼저 헤아리면 서운함이 이해로 바뀝니다.',
        'Consider their circumstances first and hurt turns into understanding.',
        '相手の事情を先に思いやれば、寂しさが理解に変わります。',
        '先体谅对方的处境，委屈会变成理解。')),
      FortuneLine(2, T(
        '사소한 말투에서 서운함이 생길 수 있습니다. 농담도 조심스럽게.',
        'A careless tone may cause hurt feelings. Be careful even with jokes.',
        'ちょっとした言い方で寂しい思いをさせるかも。冗談も慎重に。',
        '语气不当可能让人委屈。开玩笑也要注意分寸。')),
      FortuneLine(2, T(
        '과거 이야기를 꺼내면 분위기가 가라앉습니다. 현재에 집중하세요.',
        'Bringing up the past will dampen the mood. Stay in the present.',
        '過去の話を持ち出すと雰囲気が沈みます。今に集中しましょう。',
        '提起过去会让气氛低落。专注当下。')),
      FortuneLine(2, T(
        '상대의 말을 오해하기 쉬운 날. 확실하지 않으면 다시 물어보세요.',
        'Easy to misread what they say today. If unsure, ask again.',
        '相手の言葉を誤解しやすい日。はっきりしなければ聞き返しましょう。',
        '今天容易误解对方的话。不确定就再问一遍。')),
      FortuneLine(2, T(
        '질투나 비교는 관계를 해칩니다. 오늘은 SNS를 멀리하세요.',
        'Jealousy and comparison harm the relationship. Stay off social media today.',
        '嫉妬や比較は関係を傷つけます。今日はSNSから離れましょう。',
        '嫉妒和比较会伤害关系。今天远离社交媒体。')),
      FortuneLine(2, T(
        '약속 시간을 어기면 신뢰에 금이 갑니다. 여유 있게 출발하세요.',
        'Being late cracks trust. Leave with time to spare.',
        '約束の時間を守らないと信頼にひびが入ります。余裕を持って出発を。',
        '迟到会损害信任。提前出发吧。')),
      FortuneLine(1, T(
        '감정이 앞서기 쉬운 날. 다툼이 생기면 잠시 거리를 두는 것이 좋습니다.',
        'Emotions run ahead today. If an argument starts, take some distance for a while.',
        '感情が先走りやすい日。ケンカになったらしばらく距離を置くのが良いでしょう。',
        '今天容易情绪化。若起争执，暂时保持距离为好。')),
      FortuneLine(1, T(
        '기대가 크면 실망도 큽니다. 오늘은 상대에게 너무 많은 것을 바라지 마세요.',
        'High expectations bring big disappointment. Do not ask too much of them today.',
        '期待が大きいと失望も大きい。今日は相手に多くを求めないで。',
        '期望越高失望越大。今天别对对方要求太多。')),
      FortuneLine(1, T(
        '중요한 대화는 오늘 피하세요. 감정이 정리된 뒤에 나누는 것이 좋습니다.',
        'Avoid important conversations today. Have them once emotions have settled.',
        '大事な話は今日は避けましょう。気持ちが整理されてから話すのが良いです。',
        '今天避免重要谈话。等情绪平复后再谈。')),
    ],

    // ═══════════════════════════════════════════════════════════════ 금전운
    Category.money: [
      FortuneLine(5, T(
        '뜻밖의 수입이 생기거나 잊고 있던 돈이 돌아옵니다. 지갑을 정리해보세요.',
        'Unexpected income or forgotten money comes back. Tidy up your wallet.',
        '思わぬ収入があったり、忘れていたお金が戻ってきます。財布を整理してみましょう。',
        '意外的收入或忘记的钱会回来。整理一下钱包吧。')),
      FortuneLine(5, T(
        '투자나 거래에서 좋은 결과가 나오는 날. 준비된 계획이 있다면 실행하세요.',
        'Investments and deals turn out well today. If you have a plan ready, execute it.',
        '投資や取引で良い結果が出る日。準備済みの計画があるなら実行を。',
        '投资或交易今天会有好结果。有准备好的计划就执行吧。')),
      FortuneLine(5, T(
        '재물운이 활짝 열립니다. 오랫동안 기다린 보상이 도착할 수 있습니다.',
        'Wealth luck opens wide. A long-awaited reward may arrive.',
        '金運が大きく開けます。長く待っていた報酬が届くかもしれません。',
        '财运大开。期待已久的回报可能到来。')),
      FortuneLine(5, T(
        '돈이 돈을 부르는 날. 작은 투자가 좋은 결실을 맺습니다.',
        'Money attracts money today. A small investment bears good fruit.',
        'お金がお金を呼ぶ日。小さな投資が良い実を結びます。',
        '钱生钱的一天。小投资会有好收成。')),
      FortuneLine(5, T(
        '금전 관련 좋은 소식이 들립니다. 계약이나 협상이 유리하게 흘러갑니다.',
        'Good financial news arrives. Contracts and negotiations flow in your favor.',
        'お金に関する良い知らせが届きます。契約や交渉が有利に進みます。',
        '有关钱财的好消息传来。合同或谈判对你有利。')),
      FortuneLine(5, T(
        '오늘 산 물건이 오래도록 값어치를 합니다. 필요한 것을 사기 좋은 날입니다.',
        'What you buy today will hold its value for a long time. A good day to buy what you need.',
        '今日買ったものは長く価値を保ちます。必要なものを買うのに良い日です。',
        '今天买的东西会长久保值。适合购买必需品。')),
      FortuneLine(4, T(
        '작은 절약이 쌓여 큰 여유가 됩니다. 오늘 아낀 돈이 나중에 요긴하게 쓰입니다.',
        'Small savings pile up into real breathing room. Money saved today will come in handy later.',
        '小さな節約が積み重なって大きな余裕になります。今日節約したお金が後で役立ちます。',
        '积少成多，小节省带来大余裕。今天省下的钱以后会派上用场。')),
      FortuneLine(4, T(
        '금전 관련 상담이나 계약에 유리한 흐름. 조건을 꼼꼼히 따져보세요.',
        'A favorable flow for financial consultations and contracts. Check the terms carefully.',
        'お金の相談や契約に有利な流れ。条件をしっかり確認しましょう。',
        '财务咨询或签约的有利时机。仔细核对条款。')),
      FortuneLine(4, T(
        '부업이나 새로운 수입원에 대한 아이디어가 떠오릅니다. 메모해두세요.',
        'An idea for a side gig or new income source comes to mind. Write it down.',
        '副業や新しい収入源のアイデアが浮かびます。メモしておきましょう。',
        '会冒出副业或新收入来源的点子。记下来吧。')),
      FortuneLine(4, T(
        '할인이나 혜택을 발견하기 좋은 날. 평소 사려던 것이 있다면 검색해보세요.',
        'A good day to find discounts and deals. Look up that thing you have been meaning to buy.',
        '割引や特典を見つけやすい日。買おうと思っていたものを検索してみましょう。',
        '适合发现折扣和优惠的一天。搜一搜一直想买的东西。')),
      FortuneLine(4, T(
        '빌려준 돈이 돌아오거나 밀린 대금이 정산됩니다.',
        'Money you lent comes back, or an overdue payment gets settled.',
        '貸したお金が戻ってきたり、滞っていた支払いが精算されます。',
        '借出去的钱回来了，或拖欠的款项得到结算。')),
      FortuneLine(4, T(
        '재테크 공부를 시작하기 좋은 날. 오늘의 지식이 내년의 자산이 됩니다.',
        'A good day to start learning about personal finance. Today\'s knowledge becomes next year\'s assets.',
        '資産運用の勉強を始めるのに良い日。今日の知識が来年の資産になります。',
        '适合开始学习理财的一天。今天的知识是明年的资产。')),
      FortuneLine(4, T(
        '가계부를 정리하면 새는 돈이 보입니다. 작은 구독료부터 점검하세요.',
        'Review your budget and you will spot the leaks. Start with small subscriptions.',
        '家計簿を整理すると無駄なお金が見えてきます。小さなサブスクから点検を。',
        '整理账本就能发现漏财之处。先从小额订阅查起。')),
      FortuneLine(4, T(
        '지인에게서 좋은 금전 정보를 얻을 수 있습니다. 귀를 열어두세요.',
        'A friend may share a useful money tip. Keep your ears open.',
        '知人から良いお金の情報が得られるかも。耳を傾けておきましょう。',
        '可能从熟人那里得到有用的理财信息。留心听。')),
      FortuneLine(3, T(
        '수입과 지출이 균형을 이루는 날. 큰 소비만 피하면 무난합니다.',
        'Income and spending balance out. Avoid big purchases and you will be fine.',
        '収入と支出がバランスする日。大きな出費さえ避ければ無難です。',
        '收支平衡的一天。避免大额消费就没问题。')),
      FortuneLine(3, T(
        '충동구매 욕구가 올라옵니다. 장바구니에 담아두고 하루 뒤에 결정하세요.',
        'The urge to impulse-buy rises. Leave it in the cart and decide tomorrow.',
        '衝動買いの欲が高まります。カートに入れて一日置いてから決めましょう。',
        '冲动消费的欲望上升。先放进购物车，一天后再决定。')),
      FortuneLine(3, T(
        '돈보다 시간을 아끼는 선택이 결과적으로 이득입니다.',
        'Choosing to save time over money pays off in the end.',
        'お金より時間を節約する選択が結果的に得になります。',
        '省时间比省钱更划算。')),
      FortuneLine(3, T(
        '현상 유지가 최선인 날. 새로운 투자보다 기존 자산을 점검하세요.',
        'Holding steady is best today. Review existing assets rather than making new investments.',
        '現状維持が最善の日。新しい投資より既存の資産を点検しましょう。',
        '维持现状最好。与其新投资，不如盘点现有资产。')),
      FortuneLine(3, T(
        '작은 지출이 반복되기 쉬운 하루. 현금보다 카드 내역을 확인하세요.',
        'Small expenses keep piling up today. Check your card statement, not just your cash.',
        '小さな出費が重なりやすい一日。現金よりカードの明細を確認しましょう。',
        '容易反复小额消费的一天。查看一下卡的账单。')),
      FortuneLine(3, T(
        '경조사비나 선물 지출이 생길 수 있습니다. 미리 예산을 잡아두세요.',
        'Gift or occasion expenses may come up. Set a budget in advance.',
        '冠婚葬祭やプレゼントの出費があるかも。事前に予算を決めておきましょう。',
        '可能有红白喜事或礼物的开支。提前做好预算。')),
      FortuneLine(3, T(
        '돈에 대한 걱정이 많아지는 날이지만 실제 상황은 나쁘지 않습니다.',
        'Money worries grow today, but the actual situation is not bad.',
        'お金の心配が増える日ですが、実際の状況は悪くありません。',
        '今天对钱的担忧增多，但实际情况并不糟。')),
      FortuneLine(3, T(
        '무료 혜택이나 포인트를 챙기기 좋은 날. 앱 알림을 확인해보세요.',
        'A good day to collect freebies and points. Check your app notifications.',
        '無料特典やポイントを集めるのに良い日。アプリの通知を確認してみましょう。',
        '适合领取免费福利和积分的一天。看看应用通知。')),
      FortuneLine(3, T(
        '남에게 밥을 사면 그 이상으로 돌아오는 날입니다.',
        'Treat someone to a meal and it comes back with interest.',
        '人にごはんをおごると、それ以上になって返ってくる日です。',
        '请别人吃饭会得到更多回报的一天。')),
      FortuneLine(2, T(
        '예상치 못한 지출이 생길 수 있습니다. 비상금을 확인해두세요.',
        'An unexpected expense may pop up. Check your emergency fund.',
        '予想外の出費があるかもしれません。緊急資金を確認しておきましょう。',
        '可能有意外支出。检查一下备用金。')),
      FortuneLine(2, T(
        '지인과의 금전 거래는 피하는 것이 좋습니다. 관계까지 흔들릴 수 있습니다.',
        'Avoid money dealings with friends. It could shake the relationship itself.',
        '知人とのお金のやり取りは避けた方が良いです。関係まで揺らぐかもしれません。',
        '避免和熟人有金钱往来。可能连关系都受影响。')),
      FortuneLine(2, T(
        '광고나 유혹에 넘어가기 쉬운 날. 결제 전 한 번 더 생각하세요.',
        'Easy to fall for ads and temptations today. Think once more before paying.',
        '広告や誘惑に乗りやすい日。決済の前にもう一度考えましょう。',
        '今天容易被广告和诱惑打动。付款前再想一想。')),
      FortuneLine(2, T(
        '수리비나 교체 비용이 발생할 수 있습니다. 물건을 소중히 다루세요.',
        'Repair or replacement costs may come up. Handle your things with care.',
        '修理費や買い替え費用が発生するかも。物を大切に扱いましょう。',
        '可能产生维修或更换费用。爱惜物品。')),
      FortuneLine(2, T(
        '보증이나 담보 요청은 정중히 거절하세요. 오늘은 특히 조심할 때입니다.',
        'Politely decline requests to co-sign or guarantee. Be especially careful today.',
        '保証人や担保の依頼は丁重に断りましょう。今日は特に注意が必要です。',
        '婉拒担保或抵押的请求。今天要格外小心。')),
      FortuneLine(1, T(
        '손실이 따르기 쉬운 날. 새로운 투자나 큰 구매는 미루세요.',
        'Losses come easily today. Postpone new investments and big purchases.',
        '損失が出やすい日。新しい投資や大きな買い物は先送りに。',
        '今天容易有损失。推迟新投资和大额购买。')),
      FortuneLine(1, T(
        '달콤한 제안일수록 의심하세요. 오늘은 지키는 것이 버는 것입니다.',
        'The sweeter the offer, the more suspicious you should be. Today, keeping is earning.',
        '甘い話ほど疑いましょう。今日は守ることが稼ぐことです。',
        '越诱人的提议越要怀疑。今天守住就是赚到。')),
      FortuneLine(1, T(
        '지갑이 얇아지기 쉬운 하루. 외출을 줄이고 집에서 보내는 것도 방법입니다.',
        'Your wallet thins easily today. Cutting back on outings and staying home is one option.',
        '財布が薄くなりやすい一日。外出を減らして家で過ごすのも一つの方法です。',
        '钱包容易变薄的一天。减少外出、待在家里也是个办法。')),
    ],

    // ═══════════════════════════════════════════════════════════════ 직장·학업운
    Category.work: [
      FortuneLine(5, T(
        '노력이 인정받는 날입니다. 상사나 선생님에게 좋은 평가를 받을 수 있습니다.',
        'Your effort gets recognized today. Expect good feedback from a boss or teacher.',
        '努力が認められる日です。上司や先生から良い評価をもらえるでしょう。',
        '努力得到认可的一天。可能获得上司或老师的好评。')),
      FortuneLine(5, T(
        '집중력이 최고조에 달합니다. 어려운 과제를 오늘 끝내보세요.',
        'Focus peaks today. Finish that hard task now.',
        '集中力が最高潮に達します。難しい課題を今日終わらせましょう。',
        '专注力达到顶峰。今天把难题解决掉吧。')),
      FortuneLine(5, T(
        '승진이나 합격 소식이 들릴 수 있는 날. 기대해도 좋습니다.',
        'News of a promotion or acceptance may arrive. Feel free to get your hopes up.',
        '昇進や合格の知らせが届くかもしれない日。期待して良いでしょう。',
        '可能传来晋升或录取的消息。可以期待一下。')),
      FortuneLine(5, T(
        '아이디어가 샘솟는 하루. 발표나 제안에 최적의 날입니다.',
        'Ideas gush out today. Perfect for a presentation or a proposal.',
        'アイデアが湧き出る一日。発表や提案に最適な日です。',
        '灵感喷涌的一天。最适合做演讲或提案。')),
      FortuneLine(5, T(
        '막혔던 문제의 해답이 떠오릅니다. 오랫동안 고민한 것이 풀립니다.',
        'The answer to a stubborn problem comes to you. What you agonized over gets solved.',
        '行き詰まっていた問題の答えが浮かびます。長く悩んでいたことが解決します。',
        '困扰已久的问题有了答案。长期的纠结得以化解。')),
      FortuneLine(5, T(
        '팀워크가 빛나는 날. 함께하는 사람들과 큰 성과를 만듭니다.',
        'Teamwork shines today. You achieve something big with the people around you.',
        'チームワークが輝く日。一緒に働く人たちと大きな成果を生み出します。',
        '团队合作闪光的一天。与伙伴们一起创造大成果。')),
      FortuneLine(4, T(
        '동료와의 협업에서 좋은 아이디어가 나옵니다. 회의에 적극 참여하세요.',
        'Good ideas come from working with colleagues. Take an active part in meetings.',
        '同僚との協業から良いアイデアが生まれます。会議に積極的に参加しましょう。',
        '与同事协作时会有好点子。积极参与会议。')),
      FortuneLine(4, T(
        '새로운 배움이 즐거운 날. 미뤄둔 공부나 강의를 시작하기 좋습니다.',
        'Learning something new feels fun today. A good time to start that course you postponed.',
        '新しい学びが楽しい日。先延ばしにしていた勉強や講座を始めるのに良いです。',
        '学习新事物很愉快的一天。适合开始搁置的学习或课程。')),
      FortuneLine(4, T(
        '작은 성취가 자신감을 키웁니다. 할 일 목록을 하나씩 지워보세요.',
        'Small wins build confidence. Cross items off your to-do list one by one.',
        '小さな達成が自信を育てます。やることリストを一つずつ消していきましょう。',
        '小成就积累自信。把待办事项一件件划掉。')),
      FortuneLine(4, T(
        '면접이나 시험에 유리한 흐름. 준비한 만큼 실력이 발휘됩니다.',
        'A favorable flow for interviews and exams. Your preparation shows.',
        '面接や試験に有利な流れ。準備した分だけ実力が発揮されます。',
        '面试或考试的有利时机。准备多少就能发挥多少。')),
      FortuneLine(4, T(
        '선배나 멘토에게서 유용한 조언을 얻습니다. 질문을 준비해두세요.',
        'You get useful advice from a senior or mentor. Prepare your questions.',
        '先輩やメンターから有益な助言が得られます。質問を用意しておきましょう。',
        '从前辈或导师那里获得有用的建议。准备好问题。')),
      FortuneLine(4, T(
        '평소보다 일 처리 속도가 빠릅니다. 밀린 업무를 정리하기 좋은 날입니다.',
        'You work faster than usual. A good day to clear the backlog.',
        'いつもより仕事の処理が速い。溜まった仕事を片付けるのに良い日です。',
        '办事效率比平时高。适合清理积压的工作。')),
      FortuneLine(4, T(
        '실력을 보여줄 기회가 옵니다. 부담 갖지 말고 평소대로 하세요.',
        'A chance to show your skills arrives. Do not stress; just do what you always do.',
        '実力を見せるチャンスが来ます。プレッシャーを感じずいつも通りに。',
        '展示实力的机会来了。别有压力，正常发挥就好。')),
      FortuneLine(4, T(
        '새로운 프로젝트나 과목에 흥미가 생깁니다. 첫걸음을 떼보세요.',
        'You find a new project or subject interesting. Take the first step.',
        '新しいプロジェクトや科目に興味が湧きます。第一歩を踏み出してみましょう。',
        '对新项目或新科目产生兴趣。迈出第一步吧。')),
      FortuneLine(3, T(
        '평범하지만 꾸준한 하루. 오늘 한 정리가 내일의 속도를 만듭니다.',
        'An ordinary but steady day. Organizing today speeds up tomorrow.',
        '平凡だけど着実な一日。今日の整理が明日のスピードを作ります。',
        '平凡但踏实的一天。今天的整理决定明天的速度。')),
      FortuneLine(3, T(
        '멀티태스킹보다 우선순위 하나에 집중할 때 성과가 납니다.',
        'Focusing on one priority beats multitasking today.',
        'マルチタスクより優先順位一つに集中する方が成果につながります。',
        '与其多线作战，不如专注一个优先事项。')),
      FortuneLine(3, T(
        '질문을 두려워하지 마세요. 모르는 것을 묻는 것이 가장 빠른 길입니다.',
        'Do not be afraid to ask. Asking about what you do not know is the fastest route.',
        '質問を恐れないで。わからないことを聞くのが一番の近道です。',
        '别害怕提问。不懂就问是最快的路。')),
      FortuneLine(3, T(
        '루틴을 지키는 것이 최선인 날. 새로운 시도는 내일로.',
        'Keeping your routine is best today. Save new attempts for tomorrow.',
        'ルーティンを守るのが最善の日。新しい試みは明日に。',
        '坚持日常最好的一天。新尝试留到明天。')),
      FortuneLine(3, T(
        '오전에 집중력이 좋습니다. 어려운 일은 오전에, 단순한 일은 오후에.',
        'Focus is strong in the morning. Hard tasks before noon, simple ones after.',
        '午前は集中力が高い。難しい仕事は午前、単純な仕事は午後に。',
        '上午专注力好。难事上午做，简单事下午做。')),
      FortuneLine(3, T(
        '동료의 부탁이 많아질 수 있습니다. 내 일의 우선순위를 먼저 지키세요.',
        'Colleagues may ask a lot of you. Protect your own priorities first.',
        '同僚からの頼まれごとが増えるかも。自分の仕事の優先順位を先に守りましょう。',
        '同事的请求可能增多。先守住自己工作的优先级。')),
      FortuneLine(3, T(
        '복습이 효과를 발휘하는 날. 새 내용보다 배운 것을 다지세요.',
        'Review pays off today. Solidify what you learned rather than taking on new material.',
        '復習が効果を発揮する日。新しい内容より学んだことを固めましょう。',
        '复习见效的一天。巩固已学内容胜过学新知识。')),
      FortuneLine(3, T(
        '회의가 길어질 수 있습니다. 핵심만 짧게 말하는 연습을 해보세요.',
        'Meetings may run long. Practice saying only the essentials, briefly.',
        '会議が長引くかもしれません。要点だけ短く話す練習をしてみましょう。',
        '会议可能拖长。练习简短地说重点。')),
      FortuneLine(3, T(
        '작은 실수를 크게 걱정하지 마세요. 바로잡으면 오히려 신뢰가 쌓입니다.',
        'Do not fret over a small mistake. Fixing it promptly actually builds trust.',
        '小さなミスを大げさに心配しないで。すぐ直せばむしろ信頼が積み上がります。',
        '别为小失误过分担心。及时纠正反而积累信任。')),
      FortuneLine(2, T(
        '사소한 실수가 크게 보일 수 있는 날. 제출 전 한 번 더 검토하세요.',
        'A minor slip may look big today. Review once more before submitting.',
        'ちょっとしたミスが大きく見える日。提出前にもう一度確認を。',
        '小失误可能被放大的一天。提交前再检查一遍。')),
      FortuneLine(2, T(
        '의견 충돌이 생기기 쉽습니다. 한 발 물러서서 상대 입장을 들어보세요.',
        'Disagreements come easily. Step back and hear the other side.',
        '意見の衝突が起きやすい。一歩引いて相手の立場を聞いてみましょう。',
        '容易产生意见冲突。退一步，听听对方的立场。')),
      FortuneLine(2, T(
        '마감에 쫓기기 쉬운 하루. 일정을 다시 점검하고 도움을 요청하세요.',
        'Deadlines chase you today. Recheck the schedule and ask for help.',
        '締め切りに追われやすい一日。予定を見直して助けを求めましょう。',
        '容易被截止日期追赶的一天。重新检查日程，寻求帮助。')),
      FortuneLine(2, T(
        '집중이 잘 안 되는 날. 짧게 자주 쉬는 것이 오히려 효율적입니다.',
        'Hard to concentrate today. Short, frequent breaks are actually more efficient.',
        '集中しにくい日。短く頻繁に休む方がかえって効率的です。',
        '难以集中的一天。短暂而频繁的休息反而更高效。')),
      FortuneLine(2, T(
        '중요한 메일이나 메시지를 놓치기 쉽습니다. 받은 편지함을 확인하세요.',
        'Easy to miss an important email or message. Check your inbox.',
        '大事なメールやメッセージを見落としやすい。受信箱を確認しましょう。',
        '容易错过重要邮件或消息。检查收件箱。')),
      FortuneLine(1, T(
        '일이 자꾸 꼬이는 느낌이 들 수 있습니다. 오늘은 큰 일보다 작은 일을 마무리하세요.',
        'Things may keep getting tangled. Wrap up small tasks rather than big ones today.',
        '仕事がもつれる感じがするかも。今日は大きな仕事より小さな仕事を片付けましょう。',
        '可能觉得事情总是不顺。今天先完成小事，别碰大事。')),
      FortuneLine(1, T(
        '피로가 판단력을 흐립니다. 중요한 발표나 시험이 아니라면 일찍 마무리하세요.',
        'Fatigue clouds judgment. Unless it is a key presentation or exam, wrap up early.',
        '疲れが判断力を鈍らせます。大事な発表や試験でなければ早めに切り上げましょう。',
        '疲劳会影响判断。除非是重要演讲或考试，否则早点收工。')),
      FortuneLine(1, T(
        '상사나 선생님과의 마찰을 피하세요. 오늘은 말보다 행동으로 보여줄 때입니다.',
        'Avoid friction with a boss or teacher. Today, show it through action rather than words.',
        '上司や先生との摩擦は避けましょう。今日は言葉より行動で示す時です。',
        '避免与上司或老师起冲突。今天用行动代替言语。')),
    ],

    // ═══════════════════════════════════════════════════════════════ 건강운
    Category.health: [
      FortuneLine(5, T(
        '몸과 마음이 가벼운 날. 새로운 운동을 시작하기에 최적입니다.',
        'Body and mind feel light. Ideal for starting a new exercise.',
        '心も体も軽い日。新しい運動を始めるのに最適です。',
        '身心轻盈的一天。最适合开始新的运动。')),
      FortuneLine(5, T(
        '컨디션이 최상입니다. 미뤄둔 야외 활동을 계획해보세요.',
        'You are in top condition. Plan that outdoor activity you postponed.',
        'コンディションは最高です。先延ばしにしていたアウトドアを計画しましょう。',
        '状态极佳。计划一下搁置的户外活动吧。')),
      FortuneLine(5, T(
        '에너지가 넘치는 하루. 평소 힘들던 운동도 오늘은 거뜬합니다.',
        'Energy overflows today. Even workouts that usually feel hard come easy.',
        'エネルギーに満ちた一日。いつもきつい運動も今日は楽々です。',
        '活力满满的一天。平时吃力的运动今天也轻松。')),
      FortuneLine(5, T(
        '숙면을 취한 듯 개운한 아침. 이 컨디션을 유지할 습관을 만들어보세요.',
        'A refreshed morning as if after deep sleep. Build a habit that keeps this going.',
        '熟睡したかのようにすっきりした朝。この調子を保つ習慣を作ってみましょう。',
        '像睡了个好觉般清爽的早晨。养成保持这种状态的习惯吧。')),
      FortuneLine(5, T(
        '건강 검진이나 병원 방문에 좋은 결과가 나오는 날입니다.',
        'A good day for check-ups and doctor visits, with good results.',
        '健康診断や病院で良い結果が出る日です。',
        '体检或就医会有好结果的一天。')),
      FortuneLine(5, T(
        '몸이 보내는 신호가 긍정적입니다. 오늘의 활력을 마음껏 누리세요.',
        'Your body is sending positive signals. Enjoy today\'s vitality to the fullest.',
        '体からのサインがポジティブです。今日の活力を思う存分楽しみましょう。',
        '身体发出的信号很积极。尽情享受今天的活力。')),
      FortuneLine(4, T(
        '가벼운 산책만으로도 기분이 크게 좋아집니다. 햇볕을 쬐세요.',
        'Even a light walk lifts your mood a lot. Get some sunshine.',
        '軽い散歩だけでも気分がぐっと良くなります。日光を浴びましょう。',
        '轻松散步就能大大改善心情。晒晒太阳吧。')),
      FortuneLine(4, T(
        '식습관을 점검하기 좋은 날. 오늘 시작한 좋은 습관이 오래 갑니다.',
        'A good day to review your eating habits. A good habit started today lasts.',
        '食習慣を見直すのに良い日。今日始めた良い習慣は長続きします。',
        '适合检视饮食习惯的一天。今天开始的好习惯会持续很久。')),
      FortuneLine(4, T(
        '스트레칭이 몸의 긴장을 풀어줍니다. 아침에 5분만 투자하세요.',
        'Stretching releases tension. Invest just five minutes in the morning.',
        'ストレッチが体の緊張をほぐします。朝に5分だけ投資しましょう。',
        '拉伸能缓解身体紧张。早上花五分钟就好。')),
      FortuneLine(4, T(
        '물을 많이 마시면 피부와 컨디션이 함께 좋아지는 날입니다.',
        'Drink plenty of water and both skin and energy improve today.',
        '水をたくさん飲むと肌もコンディションも一緒に良くなる日です。',
        '多喝水，皮肤和状态都会变好的一天。')),
      FortuneLine(4, T(
        '가벼운 조깅이나 자전거가 활력을 줍니다. 30분이면 충분합니다.',
        'A light jog or bike ride energizes you. Thirty minutes is enough.',
        '軽いジョギングや自転車が活力をくれます。30分で十分です。',
        '轻松慢跑或骑车会带来活力。三十分钟就够。')),
      FortuneLine(4, T(
        '마음이 안정되는 하루. 명상이나 심호흡으로 하루를 시작해보세요.',
        'A day of inner calm. Start with meditation or deep breathing.',
        '心が落ち着く一日。瞑想や深呼吸で一日を始めてみましょう。',
        '内心平静的一天。用冥想或深呼吸开始新的一天。')),
      FortuneLine(4, T(
        '제철 과일과 채소가 몸에 힘을 줍니다. 오늘 장을 본다면 신선한 것으로.',
        'Seasonal fruits and vegetables give you strength. If you shop today, go fresh.',
        '旬の果物や野菜が体に力をくれます。今日買い物するなら新鮮なものを。',
        '时令果蔬为身体注入能量。今天买菜就选新鲜的。')),
      FortuneLine(4, T(
        '일찍 자고 일찍 일어나는 리듬이 잡히는 날. 내일이 더 개운합니다.',
        'An early-to-bed, early-to-rise rhythm settles in. Tomorrow feels even fresher.',
        '早寝早起きのリズムが整う日。明日はもっとすっきりします。',
        '早睡早起的节奏建立起来的一天。明天会更清爽。')),
      FortuneLine(3, T(
        '무난한 컨디션. 물을 충분히 마시고 규칙적으로 식사하세요.',
        'Average condition. Drink enough water and eat regularly.',
        '無難なコンディション。水を十分に飲み、規則正しく食事を。',
        '状态平稳。多喝水，按时吃饭。')),
      FortuneLine(3, T(
        '앉아 있는 시간이 길어질 수 있습니다. 한 시간마다 스트레칭하세요.',
        'You may sit for long stretches. Stretch every hour.',
        '座っている時間が長くなりそう。1時間ごとにストレッチを。',
        '久坐的时间可能很长。每小时拉伸一次。')),
      FortuneLine(3, T(
        '수면의 질에 신경 쓰세요. 자기 전 화면 보는 시간을 줄여보세요.',
        'Mind your sleep quality. Cut down on screen time before bed.',
        '睡眠の質に気を配って。寝る前のスクリーンタイムを減らしましょう。',
        '注意睡眠质量。减少睡前看屏幕的时间。')),
      FortuneLine(3, T(
        '카페인을 줄이면 오후가 편안합니다. 오늘은 물이나 차로 대신하세요.',
        'Less caffeine makes for an easier afternoon. Swap it for water or tea today.',
        'カフェインを減らすと午後が楽になります。今日は水やお茶で代用を。',
        '少喝咖啡因，下午会更舒服。今天用水或茶代替。')),
      FortuneLine(3, T(
        '눈의 피로가 쌓이기 쉬운 날. 멀리 있는 것을 자주 바라보세요.',
        'Eye strain builds up easily today. Look into the distance often.',
        '目の疲れがたまりやすい日。遠くをこまめに見ましょう。',
        '眼睛容易疲劳的一天。经常看看远处。')),
      FortuneLine(3, T(
        '목과 어깨가 뻐근할 수 있습니다. 자세를 자주 바꿔주세요.',
        'Neck and shoulders may feel stiff. Change your posture often.',
        '首や肩がこりやすいかも。姿勢をこまめに変えましょう。',
        '脖子和肩膀可能发僵。经常变换姿势。')),
      FortuneLine(3, T(
        '평소 컨디션이지만 무리한 운동은 삼가세요. 가볍게 움직이는 정도가 좋습니다.',
        'Normal condition, but avoid strenuous exercise. Light movement is best.',
        'いつものコンディションですが激しい運動は控えて。軽く動く程度が良いです。',
        '状态正常，但避免剧烈运动。轻度活动即可。')),
      FortuneLine(3, T(
        '기분 전환이 필요한 날. 좋아하는 음악이 몸의 긴장을 풀어줍니다.',
        'A day that needs a change of pace. Your favorite music relaxes your body.',
        '気分転換が必要な日。好きな音楽が体の緊張をほぐしてくれます。',
        '需要换换心情的一天。喜欢的音乐能放松身体。')),
      FortuneLine(3, T(
        '규칙적인 식사 시간이 하루의 리듬을 만듭니다. 끼니를 거르지 마세요.',
        'Regular mealtimes set the rhythm of your day. Do not skip meals.',
        '規則正しい食事時間が一日のリズムを作ります。食事を抜かないで。',
        '规律的用餐时间决定一天的节奏。别不吃饭。')),
      FortuneLine(2, T(
        '피로가 쌓이기 쉬운 날. 무리한 일정은 조정하고 일찍 쉬세요.',
        'Fatigue builds up easily. Adjust an overpacked schedule and rest early.',
        '疲れがたまりやすい日。無理な予定は調整して早めに休みましょう。',
        '容易疲劳的一天。调整过满的日程，早点休息。')),
      FortuneLine(2, T(
        '소화기가 예민할 수 있습니다. 자극적인 음식은 피하세요.',
        'Your stomach may be sensitive. Avoid spicy or heavy food.',
        '胃腸が敏感になるかも。刺激の強い食べ物は避けましょう。',
        '肠胃可能比较敏感。避免刺激性食物。')),
      FortuneLine(2, T(
        '두통이나 어지러움이 올 수 있습니다. 환기하고 물을 마시세요.',
        'A headache or dizziness may come. Get fresh air and drink water.',
        '頭痛やめまいが起きるかも。換気して水を飲みましょう。',
        '可能出现头痛或头晕。通通风，喝点水。')),
      FortuneLine(2, T(
        '야식이나 과식이 내일의 컨디션을 망칩니다. 저녁은 가볍게.',
        'Late-night snacks or overeating will ruin tomorrow. Keep dinner light.',
        '夜食や食べ過ぎが明日のコンディションを崩します。夕食は軽めに。',
        '夜宵或暴食会毁掉明天的状态。晚餐清淡些。')),
      FortuneLine(2, T(
        '환절기 감기 조심. 겉옷을 하나 더 챙기세요.',
        'Watch out for a seasonal cold. Bring an extra layer.',
        '季節の変わり目の風邪に注意。上着をもう一枚持ちましょう。',
        '换季小心感冒。多带一件外套。')),
      FortuneLine(1, T(
        '면역력이 떨어지는 시기. 찬 곳에 오래 있지 말고 따뜻하게 지내세요.',
        'Immunity dips now. Do not linger in the cold; stay warm.',
        '免疫力が落ちる時期。寒い場所に長くいないで暖かく過ごしましょう。',
        '免疫力下降的时期。别在冷的地方久待，注意保暖。')),
      FortuneLine(1, T(
        '스트레스가 몸으로 나타날 수 있습니다. 오늘은 휴식이 최우선입니다.',
        'Stress may show up in your body. Rest is the top priority today.',
        'ストレスが体に出るかも。今日は休息が最優先です。',
        '压力可能反映在身体上。今天休息第一。')),
      FortuneLine(1, T(
        '몸이 보내는 경고를 무시하지 마세요. 불편한 곳이 있다면 병원에 가세요.',
        'Do not ignore your body\'s warnings. If something feels off, see a doctor.',
        '体からの警告を無視しないで。不調があれば病院へ。',
        '别忽视身体的警告。哪里不舒服就去看医生。')),
    ],
  };
}
