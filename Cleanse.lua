local _, t = ...

t.repTbl = {
	--Symbol & space removal
	["[%*%-<>%(%)\"!%?=`'_%+#%%%^&;:~{}%[%] ]"]="",
	["¨"]="", ["”"]="", ["“"]="", ["▄"]="", ["▀"]="", ["█"]="", ["▓"]="", ["▲"]="", ["◄"]="", ["►"]="", ["▼"]="", ["♣"]="",
	["░"]="", ["♥"]="", ["♫"]="", ["●"]="", ["■"]="", ["☼"]="", ["¤"]="", ["☺"]="", ["↑"]="", ["«"]="", ["»"]="", ["♦"]="",
	["▌"]="", ["▒"]="", ["□"]="", ["¬"]="", ["√"]="", ["²"]="", ["´"]="", ["☻"]="", ["★"]="", ["☆"]="", ["◙"]="", ["◘"]="",
	["¦"]="", ["|"]="", [";"]="", ["΅"]="", ["™"]="", ["。"]="", ["◆"]="", ["◇"]="", ["♠"]="", ["△"]="", ["¯"]="", [" "]="",
	["《"]="", ["》"]="", ["（"]="", ["）"]="", ["～"]="", ["—"]="", ["！"]="", ["："]="", ["·"]="", ["˙"]="", ["…"]="", ["　"]="",
	["▎"]="", ["▍"]="", ["▂"]="", ["▅"]="", ["▆"]="", ["＋"]="", ["‘"]="", ["’"]="", ["【"]="", ["】"]="", ["│"]="",

	--This is the replacement table. It serves to deobfuscate words by replacing letters with their English "equivalents".
	["а"]="a", ["à"]="a", ["á"]="a", ["ä"]="a", ["â"]="a", ["ã"]="a", ["å"]="a", -- First letter is Russian "\208\176". Convert > \97.
	["Ą"]="a", ["ą"]="a", ["Ā"]="a", ["ā"]="a", ["Ă"]="a", ["ă"]="a", -- Convert > \97. Note: Ą, Ā, Ă fail with strlower, include both.
	["с"]="c", ["ç"]="c", ["Ć"]="c", ["ć"]="c", ["Č"]="c", ["č"]="c", ["Ĉ"]="c", ["ĉ"]="c", ["Ċ"]="c", ["ċ"]="c", --First letter is Russian "\209\129". Convert > \99. Note: Ć, Č, Ĉ, Ċ fail with strlower, include both.
	["Ď"]="d", ["ď"]="d", ["Đ"]="d", ["đ"]="d", --Convert > \100. Note: Ď, Đ fail with strlower, include both.
	["е"]="e", ["è"]="e", ["é"]="e", ["ë"]="e", ["ё"]="e", ["ê"]="e", --First letter is Russian "\208\181". Convert > \101.
	["Ę"]="e", ["ę"]="e", ["Ė"]="e", ["ė"]="e", ["Ě"]="e", ["ě"]="e", ["Ē"]="e", ["ē"]="e", ["Έ"]="e", ["έ"]="e", ["Ĕ"]="e", ["ĕ"]="e", ["Ε"]="e", ["ε"]="e", --Note: Ę, Ė, Ě, Ē, Έ, Ĕ, Ε fail with strlower, include both.
	["Ğ"]="g", ["ğ"]="g", ["Ĝ"]="g", ["ĝ"]="g", ["Ģ"]="g", ["ģ"]="g", ["Ġ"]="g", ["ġ"]="g", -- Convert > \103. Note: Ğ, Ĝ, Ģ, Ġ fail with strlower, include both.
	["Ĥ"]="h", ["ĥ"]="h", -- Convert > \104. Note: Ĥ fail with strlower, include both.
	["ì"]="i", ["í"]="i", ["ï"]="i", ["î"]="i", ["İ"]="i", ["ı"]="i", -- Convert > \105.
	["Ϊ"]="i", ["ϊ"]="i", ["Ι"]="i", ["ι"]="i", ["Ί"]="i", ["ί"]="i", ["Ĭ"]="i", ["ĭ"]="i", ["Ї"]="i", ["ї"]="i", --Convert > \105. -- Note: Ϊ, Ι, Ί, Ĭ, Ї fail with strlower, include both.
	["Į"]="i", ["į"]="i", ["Ĩ"]="i", ["ĩ"]="i", ["Ī"]="i", ["ī"]="i", ["Ｉ"]="i", ["ｉ"]="i", --Convert > \105. -- Note: Į, Ĩ, Ī, Ｉ fail with strlower, include both.
	["Ĵ"]="j", ["ĵ"]="j", -- Convert > \106. -- Note: Ĵ fail with strlower, include both.
	["к"]="k", ["Ķ"]="k", ["ķ"]="k", -- First letter is Russian "\208\186". Convert > \107. -- Note: Ķ fail with strlower, include both.
	["Ł"]="l", ["ł"]="l", ["Ĺ"]="l", ["ĺ"]="l", ["Ľ"]="l", ["ľ"]="l", -- Convert > \107. -- Note: Ł, Ĺ, Ľ fail with strlower, include both.
	["Μ"]="m", ["м"]="m", -- First letter is capital Greek μ "\206\156". Convert > \109
	["η"]="n", ["ή"]="n", ["ñ"]="n", ["Ν"]="n", -- First letter is small Greek eta η "\206\183". Convert > \110.
	["Ń"]="n", ["ń"]="n", ["Ņ"]="n", ["ņ"]="n", ["Ň"]="n", ["ň"]="n", ["Ŋ"]="n", ["ŋ"]="n", --Convert > \110. Note: Ń, Ņ, Ň, Ŋ fail with strlower, include both.
	["о"]="o", ["ò"]="o", ["ó"]="o", ["ö"]="o", ["ô"]="o", ["õ"]="o", ["ø"]="o", ["σ"]="o", --First letter is Russian "\208\190". Convert > \111.
	["Ō"]="o", ["ō"]="o", ["Ǿ"]="o", ["ǿ"]="o", ["Ő"]="o", ["ő"]="o", ["Θ"]="o", ["θ"]="o", ["Ŏ"]="o", ["ŏ"]="o", ["Ｏ"]="o", ["ｏ"]="o", --Note: Ō, Ǿ, Ő, Θ, Ŏ, Ｏ fail with strlower, include both.
	["р"]="p", ["þ"]="p", ["φ"]="p", ["Ρ"]="p", ["ρ"]="p", --First letter is Russian "\209\128". Convert > \112. --Note: Ρ fail with strlower, include both.
	["Ｑ"]="q", ["ｑ"]="q", --Note: Ｑ fail with strlower, include both.
	["г"]="r", ["я"]="r", ["Ř"]="r", ["ř"]="r", ["Ŕ"]="r", ["ŕ"]="r", ["Ŗ"]="r", ["ŗ"]="r", --Convert > \114. -- Note: Ř, Ŕ, Ŗ fail with strlower, include both.
	["Ş"]="s", ["ş"]="s", ["Š"]="s", ["š"]="s", ["Ś"]="s", ["ś"]="s", ["Ŝ"]="s", ["ŝ"]="s", ["Ѕ"]="s", ["ѕ"]="s", --Convert > \115. -- Note: Ş, Š, Ś, Ŝ, Ѕ fail with strlower, include both.
	["т"]="t", ["Ŧ"]="t", ["ŧ"]="t", ["Τ"]="t", ["τ"]="t", ["Ţ"]="t", ["ţ"]="t", ["Ť"]="t", ["ť"]="t", --Convert > \116. -- Note: Ŧ, Τ, Ţ, Ť fail with strlower, include both.
	["ù"]="u", ["ú"]="u", ["ü"]="u", ["û"]="u", --Convert > \117.
	["Ų"]="u", ["ų"]="u", ["Ŭ"]="u", ["ŭ"]="u", ["Ů"]="u", ["ů"]="u", ["Ű"]="u", ["ű"]="u", ["Ū"]="u", ["ū"]="u", --Convert > \117. -- Note: Ų, Ŭ, Ů, Ű, Ū fail with strlower, include both.
	["ω"]="w", ["ώ"]="w", ["Ẃ"]="w", ["ẃ"]="w", ["Ẁ"]="w", ["ẁ"]="w", ["Ŵ"]="w", ["ŵ"]="w", ["Ẅ"]="w", ["ẅ"]="w", ["Ｗ"]="w", ["ｗ"]="w", -- First letter is small Greek omega Ώ "\207\142". Convert > \119. -- Note: Ẃ, Ẁ, Ŵ, Ẅ, Ｗ fail with strlower, include both.
	["у"]="y", ["ý"]="y", ["Ÿ"]="y", ["ÿ"]="y", -- First letter is Russian "\209\131". Convert > \121. -- Note: Ÿ fail with strlower, include both.
	["０"]="0", ["１"]="1", ["２"]="2", ["３"]="3", ["４"]="4", ["５"]="5", ["６"]="6", ["７"]="7", ["８"]="8", ["９"]="9",
	["•"]=".", ["·"]=".", ["，"]=",", ["º"]="o", ["®"]="r", ["○"]="o", ["†"]="t",
}
