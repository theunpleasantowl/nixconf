local companions = {
  { name = "AMAZON", color = "#6e98e1", path = "assets/amazon.gif" },
  { name = "MAI SHIRANUI", color = "#e0a557", path = "assets/mai.gif" },
  { name = "2B // YoRHa", color = "#959dcb", path = "assets/2b.gif" },
}

local copy = {
  en = {
    {
      lines = {
        "You type quickly. Not as quickly as an axe.",
        "This timer is unnecessary. Work.",
        "Good pace. Continue.",
        "My axe is more precise than your cursor.",
      },
      reactions = {
        { type = "angry", text = "Stop clicking me." },
        { type = "angry", text = "THIS IS MY FINAL WARNING." },
        { type = "bounce", text = "...Fine. You win. I will jump." },
      },
    },
    {
      lines = {
        "You could type with a little more grace.",
        "This is not a timer. It is a dance.",
        "Speed without grace is just noise.",
        "Another session? Take care of yourself.",
      },
      reactions = {
        { type = "love", text = "Oh... you notice me that much?" },
        { type = "spin", text = "Hehe~ I will spin for you!" },
        { type = "love", text = "...I think I have grown attached to you." },
      },
    },
    {
      lines = {
        "Emotions are prohibited. Still... I am watching.",
        "Mission in progress. Continue working.",
        "System operational. Anomalies: 0.",
        "Connection stable. Systems normal.",
      },
      reactions = {
        { type = "glow", text = "Abnormal operator behavior detected." },
        { type = "glow", text = "This level of interaction exceeds normal parameters." },
        { type = "glow", text = "...Pod. Record this. The operator trusts me." },
      },
    },
  },
  pt = {
    {
      lines = {
        "Voce digita rapido. Nao tao rapido quanto um machado.",
        "Esse cronometro e desnecessario. Trabalhe.",
        "Bom ritmo. Continue.",
        "Meu machado e mais preciso que seu cursor.",
      },
      reactions = {
        { type = "angry", text = "Pare de clicar em mim." },
        { type = "angry", text = "ESTE E MEU AVISO FINAL." },
        { type = "bounce", text = "...Tudo bem. Voce venceu. Eu vou pular." },
      },
    },
    {
      lines = {
        "Voce poderia digitar com um pouco mais de graca.",
        "Isto nao e um cronometro. E uma danca.",
        "Velocidade sem graca e so barulho.",
        "Outra sessao? Cuide-se.",
      },
      reactions = {
        { type = "love", text = "Ah... voce me nota tanto assim?" },
        { type = "spin", text = "Hehe, eu vou girar para voce!" },
        { type = "love", text = "...Acho que me apeguei a voce." },
      },
    },
    {
      lines = {
        "Emocoes sao proibidas. Ainda assim... estou observando.",
        "Missao em andamento. Continue trabalhando.",
        "Sistema operacional. Anomalias: 0.",
        "Conexao estavel. Sistemas normais.",
      },
      reactions = {
        { type = "glow", text = "Comportamento anormal do operador detectado." },
        { type = "glow", text = "Este nivel de interacao excede parametros normais." },
        { type = "glow", text = "...Pod, registre isto. O operador confia em mim." },
      },
    },
  },
  ja = {
    {
      lines = {
        "入力は速い。だが斧ほどではない。",
        "タイマーは不要だ。作業しろ。",
        "いいペースだ。続けろ。",
        "私の斧は君のカーソルより正確だ。",
      },
      reactions = {
        { type = "angry", text = "クリックするな。" },
        { type = "angry", text = "これが最後の警告だ。" },
        { type = "bounce", text = "...いいだろう。君の勝ちだ。跳んでやる。" },
      },
    },
    {
      lines = {
        "もう少し優雅に打てるはずよ。",
        "これはタイマーじゃない。舞よ。",
        "優雅さのない速さは、ただの雑音。",
        "また一仕事？ 体も大事にしてね。",
      },
      reactions = {
        { type = "love", text = "あら...そんなに見てくれていたの？" },
        { type = "spin", text = "ふふ、回ってあげる！" },
        { type = "love", text = "...少し、情が移ったみたい。" },
      },
    },
    {
      lines = {
        "感情は禁止。それでも...監視している。",
        "任務進行中。作業を継続。",
        "システム正常。異常: 0。",
        "接続安定。各系統正常。",
      },
      reactions = {
        { type = "glow", text = "異常な操作者行動を検出。" },
        { type = "glow", text = "この接触頻度は通常値を超過。" },
        { type = "glow", text = "...ポッド、記録して。操作者は私を信頼している。" },
      },
    },
  },
}

local current = 1
local visible = true
local bubbleVisible = false
local bubbleText = ""
local clickCount = 1

local function activeCopy()
  local lang = noctalia.getConfig("language") or "en"
  return copy[lang] or copy.en
end

local function companionData()
  return activeCopy()[current] or activeCopy()[1]
end

local function randomLine()
  local data = companionData()
  local idx = math.random(1, #data.lines)
  return data.lines[idx]
end

local function reactionText()
  local data = companionData()
  local stage = math.min(clickCount, #data.reactions)
  return data.reactions[stage].text
end

function update()
  -- The desktop widget renders on demand, so no periodic update is needed.
end

function render()
  local scale = noctalia.getConfig("scaleFactor") or 1.0
  local size = math.floor(128 * scale)
  local c = companions[current]

  if not visible then
    desktopWidget.render(ui.column({ visible = false, fill = true }, {}))
    return
  end

  local bubble = nil
  if bubbleVisible then
    bubble = ui.box({ fill = "surface_variant/0.9", radius = 8, padding = 10, width = size + 48 }, {
      ui.label({ text = c.name, fontWeight = "bold", color = c.color, fontSize = 12 }),
      ui.label({ text = bubbleText, fontSize = 12, maxLines = 4 }),
    })
  end

  desktopWidget.render(ui.column({ gap = 8, align = "center", fill = true }, {
    bubble,
    ui.row({ gap = 6, align = "center" }, {
      ui.button({ text = "<", onClick = "prevCompanion" }),
      ui.image({ path = c.path, width = size, height = size, fit = "contain", onClick = "onImageClick" }),
      ui.button({ text = ">", onClick = "nextCompanion" }),
    }),
    ui.label({ text = c.name, fontWeight = "bold", color = c.color, fontSize = 12 }),
  }))
end

function onImageClick()
  clickCount = clickCount + 1
  if clickCount > 3 then
    bubbleText = reactionText()
    clickCount = 0
  else
    bubbleText = randomLine()
  end
  bubbleVisible = true
  render()
end

function prevCompanion()
  current = current - 1
  if current < 1 then
    current = #companions
  end
  clickCount = 0
  bubbleVisible = false
  render()
end

function nextCompanion()
  current = current % #companions + 1
  clickCount = 0
  bubbleVisible = false
  render()
end

function onIpc(event, payload)
  if event == "toggle" then
    visible = not visible
  elseif event == "show" then
    visible = true
  elseif event == "hide" then
    visible = false
  end
  render()
end

render()
