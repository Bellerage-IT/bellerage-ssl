
&После("ПриЧтенииПараметраЗапроса")
Процедура тест_ПриЧтенииПараметраЗапроса(Параметр, Значение, ЗначениеПрочитано) Экспорт
	Тип = ВРЕГ(Параметр.Тип);
	Если Тип = тест_Фабрика().ДатаБО Тогда
		ЗначениеПрочитано = Истина;
		Значение = Дата(Строка(Значение));
	КонецЕсли;
КонецПроцедуры

Функция тест_Фабрика() Экспорт
	Возврат Новый ФиксированнаяСтруктура("ДатаБО", "ДАТА_БО");
КонецФункции