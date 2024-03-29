// @strict-types

#Область ПрограммныйИнтерфейс

// Сохранить значение константы
// 
// Параметры:
//  Ключ - Строка
//  Значение - см. РегистрСведений.бф_ЗначенияКонстант.Значение
//  Дата - Неопределено,Дата
Процедура Сохранить(Ключ, Значение, Дата = Неопределено) Экспорт
	
	Запись = РегистрыСведений.бф_ЗначенияКонстант.СоздатьМенеджерЗаписи();
	Запись.Заполнить(Неопределено);
	Запись.Ключ = Ключ;
	Запись.Значение = Значение;
	Запись.Период = ?(Не ЗначениеЗаполнено(Дата), ТекущаяДатаСеанса(), Дата);          	
	Запись.Записать();
	
	ЗаписьЖурналаРегистрации(
		КодСобытияЖР("СохранениеКонстанты"),
		УровеньЖурналаРегистрации.Информация,
		,
		,
		СтрШаблон("Установлена константа с ключом: %1, и значением: %2", Ключ, Значение)
	);
	
КонецПроцедуры       

// Значение константы.
// Можно использовать в цикле, так как значения констант кешируются
// 
// Параметры:
//  Ключ - Строка - Ключ
//  Дата - Неопределено,Дата - Дата на которую надо получить значение. Если не указана, то берется последнее значение
// 
// Возвращаемое значение:
// см. РегистрСведений.бф_ЗначенияКонстант.Значение
Функция ЗначениеКонстанты(Ключ, Дата = Неопределено) Экспорт   
	УстановитьПривилегированныйРежим(Истина);
	Значение = бф_КонстантыПовтИсп.ЗначенияКонстант(Дата).Получить(Ключ);
	УстановитьПривилегированныйРежим(Ложь);
	Возврат Значение;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КодСобытияЖР(ИмяСобытия)
	Возврат СтрШаблон("бф_Константы.%1", ИмяСобытия);
КонецФункции
#КонецОбласти
