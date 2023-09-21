// @strict-types

#Область ПрограммныйИнтерфейс

// Типы параметров запроса, можно дополнить в см. бф_ФабрикаХТТППереопределяемый
// 
// Возвращаемое значение:
//  ФиксированнаяСтруктура - Типы параметров запроса:
// * Строка - Строка
// * Булево - Строка
// * Число - Строка
// * Дата - Строка
// * ДатаВремя - Строка
// * Гуид - Строка
Функция ТипыПараметровЗапроса() Экспорт
	Возврат бф_ФабрикаХТТППовтИсп.ТипыПараметровЗапроса();
КонецФункции

// Возвращает коды стандартных типов ошибок, можно переопределить в см. бф_ФабрикаХТТППереопределяемый
// 
// Возвращаемое значение:
//  ФиксированнаяСтруктура - Коды типов ошибок:
// * ОшибкаВалидации - Строка
// * ОшибкаДоступа - Строка
// * ОшибкаСервера - Строка
Функция КодыТиповОшибок() Экспорт
	Возврат бф_ФабрикаХТТППовтИсп.КодыТиповОшибок();
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Описанией полной фабрики типов
// 
// Возвращаемое значение:
//	ФиксированнаяСтруктура 
Функция ПолнаяФабрикаТиповПараметровЗапроса() Экспорт
	Возврат бф_ФабрикаХТТППовтИсп.ПолнаяФабрикаТиповПараметровЗапроса();
КонецФункции

#КонецОбласти

//@skip-check module-region-empty
#Область СлужебныеПроцедурыИФункции

// Код процедур и функций

#КонецОбласти
