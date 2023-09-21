// @strict-types


/////////////////////////////////////////////////////////////////////////////////
// Экспортные процедуры и функции, предназначенные для использования другими 
// объектами конфигурации или другими программами
///////////////////////////////////////////////////////////////////////////////// 
#Область СлужебныйПрограммныйИнтерфейс

Процедура ИсполняемыеСценарии() Экспорт
	
	ЮТТесты
		.ДобавитьТест("ИнициализацияКомпоненты", "Иницализация компоненты в синхронном режиме")
		.ДобавитьТест("СовпадениеСтрокиБезПодгрупп", "Совпадение строки без подгрупп")
		.ДобавитьТест("СовпадениеСтрокиСПодгруппами", "Совпадение строки с подгруппами")
	;
		
КонецПроцедуры

#Область События

#КонецОбласти

Процедура ИнициализацияКомпоненты() Экспорт
	ЮТест.ОжидаетЧто(бф_РегулярныеВыраженияКлиентСервер)
		.Метод("КомпонентаРаботыСРегулярнымиВыражениями").НеВыбрасываетИсключение()
	;
КонецПроцедуры

Процедура СовпадениеСтрокиБезПодгрупп() Экспорт
	Результат = бф_РегулярныеВыраженияКлиентСервер.Совпадает(
		"http://regex101.com/r/mH1fN5",
		"^http(?:s?):\/\/regex101\.com\/r\/([a-zA-Z0-9]{1,6})?$"
	);
	ЮТест.ОжидаетЧто(Результат).ЭтоИстина();
КонецПроцедуры

Процедура СовпадениеСтрокиСПодгруппами() Экспорт
	ТекстПоиска = "http://regex101.com/r/fW0vZ2test";
	Результат = бф_РегулярныеВыраженияКлиентСервер.НайтиСовпадения(
		ТекстПоиска,
		"^http(?:s?):\/\/regex101\.com\/r\/([a-zA-Z0-9]{1,6}(.*))?$",
		Истина
	);
	
	ЮТест.ОжидаетЧто(Результат.Получить(ТекстПоиска))
		.ЭтоНеНеопределено()
		.Элемент(0)
			.Равно("fW0vZ2test")
		.Элемент(1)
			.Равно("test")
	;
КонецПроцедуры

#КонецОбласти
