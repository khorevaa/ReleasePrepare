#Использовать json
#Использовать cmdline
// #Использовать asserts
// #Использовать strings
#Использовать 1commands
#Использовать tempfiles
#Использовать fs

Перем ПутьК1С;
Перем ПроектКлюч;
Перем ПроектФайл;
Перем ПроектИмя;
Перем База1С;
Перем ПользовательИмя;
Перем ПользовательПароль;
Перем КаталогРелизов;
Перем ИмяРелиза;
Перем КаталогДампа;
// Перем ПутьOScript;


Процедура ЧтениеПараметров(МенеджерПараметров, ИмяПроекта)
    МенеджерПараметров.УстановитьФайлПараметров("Настройки.json");
    МенеджерПараметров.Прочитать();

  	oscript_dir  = МенеджерПараметров.Параметр("oscript_dir");
	КаталогПроекта = МенеджерПараметров.Параметр(ИмяПроекта +".Каталоги.Проект");
	КаталогРелизов = МенеджерПараметров.Параметр(ИмяПроекта +".Каталоги.Релиз");
	КаталогДампа  = МенеджерПараметров.Параметр(ИмяПроекта +".Каталоги.Исходники");
КонецПроцедуры


// Формирует строку повторяющихся символов заданной длины.
//
// Параметры:
//  Символ      - Строка - IN - символ, из которого будет формироваться строка.
//  ДлинаСтроки - Число  - IN - требуемая длина результирующей строки.
//
// Возвращаемое значение:
//  Строка - строка, состоящая из повторяющихся символов.
Функция СтрокаСимволов(Знач Символ, Знач ДлинаСтроки) Экспорт
	Результат = "";
	Для Счетчик = 1 По ДлинаСтроки Цикл
		Результат = Результат + Символ;
	КонецЦикла;
	Возврат Результат;
КонецФункции


Процедура PrintLine(char="-", length=60)
	// СтрФунк = Новый СтроковыеФункции;
	// СтрокаСимволов = СтрФунк.СформироватьСтрокуСимволов(char, length);
	// СтрокаСимволов = СтрокаСимволов(char, length);
	Сообщить(СтрокаСимволов(char, length));
КонецПроцедуры


Функция ВзятьВКавычки(Строка)
	Возврат """" + Строка + """";
КонецФункции


Процедура ОбработкуРазобрать(ПутьКФайлу, КаталогДампа)
	// extractor = ЗагрузитьСценарий(ОбъединитьПути(oscript_dir, "lib\precommit1c\v8files-extractor.os"));
	// extractor.Декомпилировать( КаталогПроекта, КаталогДампа);

	Команда = Новый Команда;
	// Команда.УстановитьКоманду(ПутьК1С);
	// Команда.ДобавитьПараметр("DESIGNER");
	// Команда.ДобавитьПараметр("/F " + База1С);
	// Команда.ДобавитьПараметр("/N " + ПользовательИмя);
	// Команда.ДобавитьПараметр("/P " + ПользовательПароль);
	// Команда.ДобавитьПараметр("/DumpExternalDataProcessorOrReportToFiles " + ОбъединитьПути(КаталогДампа, ПроектКлюч));
	// Команда.ДобавитьПараметр(ПутьКФайлу);
	// Команда.ДобавитьПараметр("/Out " + ОбъединитьПути(КаталогДампа, "log.txt"));

	СтрокаЗапуска = ВзятьВКавычки(ПутьК1С) + " DESIGNER"
		+ " /F" + ВзятьВКавычки(База1С)
		+ " /N" + ВзятьВКавычки(ПользовательИмя)
		+ " /P" + ВзятьВКавычки(ПользовательПароль)
		+ " /DumpExternalDataProcessorOrReportToFiles" + КаталогДампа
		+ " " + ПутьКФайлу
		+ " /Out" + ОбъединитьПути(КаталогДампа, "log.txt");
	Сообщить(СтрокаЗапуска);
	Команда.УстановитьСтрокуЗапуска(СтрокаЗапуска);
	КодВозврата = Команда.Исполнить();
	Сообщить(КодВозврата);
	// Сообщить(Команда.ПолучитьВывод());
КонецПроцедуры


Процедура ПодготовитьИсходникиКРелизу(Каталог)
	Сообщить(Каталог);
	Файлы = НайтиФайлы(Каталог, "*.bsl", Истина);
	Для Каждого НайденныйФайл Из Файлы Цикл
		Если НайденныйФайл.ЭтоФайл() Тогда
			ОбработатьФайл(НайденныйФайл.ПолноеИмя);
		// ИначеЕсли НайденныйФайл.ЭтоКаталог() Тогда
		// 	ПодготовитьИсходникиКРелизу(НайденныйФайл)
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры


Функция ПолучитьИмяПроекта(КаталогДампа)
	Файлы = НайтиФайлы(КаталогДампа, "*.*", Ложь);
	Для Каждого НайденныйФайл Из Файлы Цикл
		Если НайденныйФайл.ЭтоКаталог() Тогда
			Возврат НайденныйФайл.Имя;
		КонецЕсли;
	КонецЦикла;
КонецФункции


Функция ПолучитьИмяРелиза(КаталогДампа)
	Файлы = НайтиФайлы(ОбъединитьПути(КаталогДампа, ПроектИмя, "Ext\ObjectModule.bsl"), Ложь);
	Для Каждого НайденныйФайл Из Файлы Цикл
		Если НайденныйФайл.ЭтоФайл() Тогда
			Возврат НайденныйФайл.ПолноеИмя;
		КонецЕсли;
	КонецЦикла;
КонецФункции


Процедура ОбработатьФайл(ИмяФайла)
	Сообщить(ИмяФайла);
КонецПроцедуры


Процедура ОбработкуСобрать(ПутьКФайлу, КаталогРелизов)
	Перем XMLСборки;

	Команда = Новый Команда;
	СтрокаЗапуска = ВзятьВКавычки(ПутьК1С) + " DESIGNER"
		+ " /F" + ВзятьВКавычки(База1С)
		+ " /N" + ВзятьВКавычки(ПользовательИмя)
		+ " /P" + ВзятьВКавычки(ПользовательПароль)
		+ " /LoadExternalDataProcessorOrReportFromFiles" + XMLСборки
		+ " " + ОбъединитьПути(КаталогРелизов, ИмяРелиза)
		+ " /Out" + ОбъединитьПути(КаталогДампа, "log.txt");
	Сообщить(СтрокаЗапуска);
	Команда.УстановитьСтрокуЗапуска(СтрокаЗапуска);
	// КодВозврата = Команда.Исполнить();
	// Сообщить(КодВозврата);
	// Сообщить(Команда.ПолучитьВывод());
КонецПроцедуры


Парсер = Новый ПарсерАргументовКоманднойСтроки();
Парсер.ДобавитьПараметр("ПроектКлюч");
Парсер.ДобавитьИменованныйПараметр("-project");

АргументыЗапуска = Парсер.Разобрать(АргументыКоманднойСтроки);
ПроектКлюч = АргументыЗапуска["ПроектКлюч"];
// dlmPath	= ПолучитьРазделительПути();
// CurrentDir = "";
Если НЕ АргументыЗапуска[ПроектКлюч] = Неопределено Тогда
	ПроектКлюч = АргументыЗапуска["ПроектКлюч"];
Иначе
	// ПроектКлюч = CurrentDir;
	// КаталогПроекта = Новый Файл(ТекущийСценарий().Источник).Путь
КонецЕсли;
Сообщить(Новый Файл(ТекущийСценарий().Источник).Путь);

ПроектКлюч = "Test_Release";
ЧтениеJSON = Новый ЧтениеJSON();
ЧтениеJSON.ОткрытьФайл("config1251.json");
НастройкиЗапуска = ПрочитатьJSON(ЧтениеJSON, False);

PrintLine("=");
Если НЕ НастройкиЗапуска.Свойство(ПроектКлюч) Тогда
	Сообщить("В config.json отсутствует описание проекта: " + ПроектКлюч);
	Exit(0);
Иначе
	НастройкиПроекта = НастройкиЗапуска[ПроектКлюч];
КонецЕсли;
// system_conf = НастройкиЗапуска["Programs"];

ПутьК1С  = НастройкиЗапуска["Programs"]["v83"];

Если НЕ НастройкиПроекта.Свойство("ФайлПроекта") Тогда
	Сообщить("В config.json отсутствует описание пути к файлу обработки: " + ПроектКлюч);
	Exit(0);
Иначе
	ПроектФайл = НастройкиПроекта["ФайлПроекта"];
КонецЕсли;
База1С = НастройкиПроекта["База1С"];
ПользовательИмя = НастройкиПроекта["Пользователь1С"]["Имя"];
ПользовательПароль = НастройкиПроекта["Пользователь1С"]["Пароль"];

// КаталогДампа = ОбъединитьПути(КаталогВременныхФайлов(), ПроектКлюч);
КаталогДампа = ВременныеФайлы.СоздатьКаталог(ПроектКлюч);

КаталогРелизов = НастройкиЗапуска["КаталогРелизов"];
// SourceFileExt = "bsl";

Сообщить("Ключ проекта   : " + ПроектКлюч);
Сообщить("Файл проекта   : " + ПроектФайл);
Сообщить("Путь к 1С      : " + ПутьК1С);
Сообщить("Файл базы 1С   : " + База1С);
Сообщить("Имя польз.     : " + ПользовательИмя);
Сообщить("Пароль польз.  : " + ПользовательПароль);
Сообщить("Каталог дампа  : " + КаталогДампа);
Сообщить("Каталог релизов: " + КаталогРелизов);
// Сообщить("Каталог OScirpt   : " + oscript_dir);

ОбработкуРазобрать(ПроектФайл, КаталогДампа);

ПроектИмя = ПолучитьИмяПроекта(КаталогДампа);
ФайлСборки = ОбъединитьПути(КаталогДампа, ПроектИмя + ".xml");
Сообщить("Имя проекта   : " +ПроектИмя);
Сообщить("Файл сборки   : " + ФайлСборки);

// ПодготовитьИсходникиКРелизу(КаталогДампа);

ИмяРелиза = ПолучитьИмяРелиза(КаталогДампа);
ФайлРелиза = ОбъединитьПути(КаталогРелизов, ИмяРелиза);
Сообщить("Имя релиза    : " + ФайлРелиза);
// ОбработкуСобрать(ПроектФайл, КаталогРелизов);

