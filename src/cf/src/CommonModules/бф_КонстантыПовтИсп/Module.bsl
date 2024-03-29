// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Значения констант.
// 
// Параметры:
//  Дата - Дата
// 
// Возвращаемое значение:
//  ФиксированноеСоответствие из КлючИЗначение:
//  	* Ключ - см. РегистрСведений.бф_ЗначенияКонстант.Ключ
//  	* Значение - см. РегистрСведений.бф_ЗначенияКонстант.Значение
Функция ЗначенияКонстант(Дата) Экспорт
	
	ВыборкаДетальныеЗаписи = ВыборкаЗначенияКонстант(Дата);
	
	Результат = Новый Соответствие();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Результат.Вставить(ВыборкаДетальныеЗаписи.Ключ, ВыборкаДетальныеЗаписи.Значение);
	КонецЦикла;                                                                          
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выборка значения констант.
// 
// Параметры:
//  Дата - Дата
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса - Выборка значения констант:
//  	* Ключ - см. РегистрСведений.бф_ЗначенияКонстант.Ключ
//  	* Значение - см. РегистрСведений.бф_ЗначенияКонстант.Значение
Функция ВыборкаЗначенияКонстант(Дата)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бф_ЗначенияКонстантСрезПоследних.Ключ КАК Ключ,
	|	бф_ЗначенияКонстантСрезПоследних.Значение КАК Значение
	|ИЗ
	|	РегистрСведений.бф_ЗначенияКонстант.СрезПоследних(&Период, ) КАК бф_ЗначенияКонстантСрезПоследних";
	
	Запрос.УстановитьПараметр("Период", Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Возврат ВыборкаДетальныеЗаписи;
	
КонецФункции

#КонецОбласти