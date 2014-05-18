# -*- encoding=utf-8 -*-
import snip
def dateout(yor, month, day, weekday, boolweek, kasus):
	weekday  = datetime.date(yor, month, day).weekday()
	if day<10: tog = str(day)+"ט"
	else: tog = str(day)+"סט"
	if snip.opt(precomposed, True):	
		khadoshim = ["יאַנואַר", "פֿעברואַר", "מאַרץ", "אַפּריל", "מײַ", "יוני", "יולי", "אױגוסט", "סעפּטעמבער", "אָקטאָבער", "נאָװעמבער", "דעצעמבער"]
		vokhntogn = ["מאָנטיק", "דינסטיק", "מיטװאָך", "דאָנערשטיק", "פֿרײַטיק", "שבת", "זונטיק"]
	else:
		khadoshim = ["יאַנואַר", "פֿעברואַר", "מאַרץ", "אַפּריל", "מײַ", "יוני", "יולי", "אױגוסט", "סעפּטעמבער", "אָקטאָבער", "נאָװעמבער", "דעצעמבער"]
		vokhntogn = ["מאָנטיק", "דינסטיק", "מיטװאָך", "דאָנערשטיק", "פֿרײַטיק", "שבת", "זונטיק"]
	khoydesh  = khadoshim[month-1]
	vokhntog  = vokhntogn[weekday]
	if boolweek:
		print vokhntog + ",",
	if kasus == "nom":
		print "דער " + tog + "ער " + khoydesh + " " + yor  
	elif kasus == "akk":
		print "דעם " + tog + "ן " + khoydesh + " " + yor  
