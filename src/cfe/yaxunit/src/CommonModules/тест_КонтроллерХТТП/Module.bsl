#Область СлужебныйПрограммныйИнтерфейс

// Тестовый обработчик с исключением
// 
// Параметры:
//  Запрос - HTTPСервисЗапрос - Входящий запрос
//  МетаданныеСервиса - ОбъектМетаданныхHTTPСервис - Исходные метаданные сервиса
// 
// Возвращаемое значение:
//	HTTPСервисОтвет - Ответ
Функция ОбработчикСИсключением(Запрос, МетаданныеСервиса) Экспорт
	
	Результат = Новый Структура("_1,_2,_3", 1,2,3);
	Результат._4 = Результат._1;
	Возврат бф_СервисыОбщее.ОтветИзОбъекта(Результат)
		
КонецФункции

// Тестовый обработчик с ошибкой доступа
// 
// Параметры:
//  Запрос - HTTPСервисЗапрос - Входящий запрос
//  МетаданныеСервиса - ОбъектМетаданныхHTTPСервис - Исходные метаданные сервиса
// 
// Возвращаемое значение:
//	HTTPСервисОтвет - Ответ
Функция ОбработчикСОшибкойДоступа(Запрос, МетаданныеСервиса) Экспорт
	
	бф_СервисыОбщее.ВызватьИсключениеДоступа("no access");
	Возврат бф_СервисыОбщее.ОтветПоКоду(200);
	
КонецФункции

// Тестовый обработчик с ошибкой валидации
// 
// Параметры:
//  Запрос - HTTPСервисЗапрос - Входящий запрос
//  МетаданныеСервиса - ОбъектМетаданныхHTTPСервис - Исходные метаданные сервиса
// 
// Возвращаемое значение:
//	HTTPСервисОтвет - Ответ
Функция ОбработчикСОшибкойВалидации(Запрос, МетаданныеСервиса) Экспорт
	
	бф_СервисыОбщее.ВызватьИсключениеВалидация("wrong data");
	Возврат бф_СервисыОбщее.ОтветПоКоду(200);
	
КонецФункции

// Тестовый обработчик с кастомной валидации
// 
// Параметры:
//  Запрос - HTTPСервисЗапрос - Входящий запрос
//  МетаданныеСервиса - ОбъектМетаданныхHTTPСервис - Исходные метаданные сервиса
// 
// Возвращаемое значение:
//	HTTPСервисОтвет - Ответ
Функция ОбработчикСКастомнойОшибкой(Запрос, МетаданныеСервиса) Экспорт
	
	бф_СервисыОбщее.ВызватьИсключениеПроверки(
		"Недостаточно средств на счете",
		"OUT_OF_CREDIT",
		"У вас недостаточно средств на счете, необходимо еще 200 рублей",
		Новый Структура("balance", 400)
	);
	Возврат бф_СервисыОбщее.ОтветПоКоду(200);
	
КонецФункции

#КонецОбласти

