#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	ЗаписатьЗакрытьНаСервере();      
	Модифицированность = Ложь;
	ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.бф_ЗначенияКонстант"));
	Закрыть();
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаписатьЗакрытьНаСервере()
	бф_Константы.Сохранить(Запись.Ключ, Запись.Значение, Запись.Период);
КонецПроцедуры

#КонецОбласти
