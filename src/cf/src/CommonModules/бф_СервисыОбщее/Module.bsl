// @strict-types

#Область ПрограммныйИнтерфейс

#Область ЧтениеЗапроса

// Извлечь тело запроса по указанной схеме
// 
// Параметры:
//  Источник - HTTPСервисЗапрос,Строка,Поток,ДвоичныеДанные - Источник для извлечения
//  ТипXDTO - ТипОбъектаXDTO,ТипЗначенияXDTO - Источник хттп
//  ДопПараметры - Неопределено, Структура - Доп параметры (Параметры прокидываются во всех переопределяемые процедуры)
//  Кодировка - Строка,КодировкаТекста - Кодировка считывания тела запроса
// 
// Возвращаемое значение:
//  ОбъектXDTO,СписокXDTO
Функция ИзвлечьТелоJSONПоСхеме(Источник, ТипXDTO, ДопПараметры = Неопределено, Кодировка = Неопределено) Экспорт
	
	ЧтениеJson = ЧтениеJsonИзИсточника(Источник, Кодировка);
	
	Попытка
		//@skip-check invocation-parameter-type-intersect,wrong-type-expression
		ОбъектXDTO = ФабрикаXDTO.ПрочитатьJSON(
			ЧтениеJSON,
			ТипXDTO,
			"ВосстановитьЗначениеXDTO", // Можно переопределить в см. бф_ВосстановлениеXDTOПереопределяемый 
			бф_ВосстановлениеXDTO,
			ДопПараметры
		); // ОбъектXDTO, СписокXDTO
	Исключение
		ТекстОшибки = ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключениеВалидация(ТекстОшибки);
	КонецПопытки;
	
	Возврат ОбъектXDTO;
	
КонецФункции

// Читает тело запроса, проверяет по схеме и восстановливает в прикладной формат
// Является аналогом вызова 2 методов: см. бф_СервисыОбщее.ИзвлечьТелоJSONПоСхеме и 
// См. бф_ВосстановлениеXDTO.КонвертироватьИзФормата
// 
// Параметры:
//  Источник - см. ИзвлечьТелоJSONПоСхеме.Источник
//  ТипXDTO - см. ИзвлечьТелоJSONПоСхеме.ТипXDTO
//  ФункцииВосстановления - см. бф_ВосстановлениеXDTO.КонвертироватьИзФормата.ФункцииВосстановления
//  ДопПараметры - см. ИзвлечьТелоJSONПоСхеме.ДопПараметры
// 
// Возвращаемое значение:
// 	см. бф_ВосстановлениеXDTO.КонвертироватьИзФормата
Функция ПрочитатьИВосстановить(Источник, ТипXDTO, ФункцииВосстановления = Неопределено, ДопПараметры = Неопределено) Экспорт
	Возврат бф_ВосстановлениеXDTO.КонвертироватьИзФормата(
		ИзвлечьТелоJSONПоСхеме(Источник, ТипXDTO, ДопПараметры),
		ФункцииВосстановления,
		ДопПараметры
	);
КонецФункции

// Извлекает параметры из запроса, проверяет наличие обязательных параметров, преобразует
// параметры запроса в примитивные типы, переименовывает параметры в локальное представление
// 
// Параметры:
//  Запрос - HTTPСервисЗапрос
//  ПроверяемыеПараметры - Массив из см. НовыйПараметрЗапроса
// 
// Возвращаемое значение:
//  Соответствие из КлючИЗначение - Параметры запроса:
//	* Ключ - Строка
//	* Значение - Строка,Булево,Число,Дата
Функция ПараметрыЗапроса(Запрос, ПроверяемыеПараметры) Экспорт
	
	ПараметрыЗапроса = Новый Соответствие();
	
	Для Каждого Элемент Из Запрос.ПараметрыЗапроса Цикл
		ПараметрыЗапроса.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
	Для Каждого Элемент Из Запрос.ПараметрыURL Цикл
		ПараметрыЗапроса.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
	
	Для Каждого ЗапрашиваемыйПараметр Из ПроверяемыеПараметры Цикл
		Если ЗапрашиваемыйПараметр.Обязательный И ПараметрыЗапроса.Получить(ЗапрашиваемыйПараметр.Имя) = Неопределено Тогда
			ВызватьИсключениеВалидация(СтрШаблон("No required parameter [%1]", ЗапрашиваемыйПараметр.Имя));
		КонецЕсли;
		
		Если ПараметрыЗапроса.Получить(ЗапрашиваемыйПараметр.Имя) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначениеПараметра = ПараметрыЗапроса.Получить(ЗапрашиваемыйПараметр.Имя); // Строка
		
		Если ЗапрашиваемыйПараметр.ВозможныеЗначения.Количество() > 0
			И ЗапрашиваемыйПараметр.ВозможныеЗначения.Найти(НРег(ЗначениеПараметра)) = Неопределено Тогда
				ТекстОшибки = СтрШаблон(
					"Invalid parameter value for parameter [%1], only following values are available [%2]",
					ЗапрашиваемыйПараметр.Имя,
					СтрСоединить(ЗапрашиваемыйПараметр.ВозможныеЗначения, ",")
				);
				ВызватьИсключениеВалидация(ТекстОшибки);
		КонецЕсли;
		
		Тип = ВРЕГ(ЗапрашиваемыйПараметр.Тип);
		ФабрикаТипов = бф_ФабрикаХТТП.ТипыПараметровЗапроса();
		Если Тип = ФабрикаТипов.Булево Тогда
			Попытка
				ЗначениеБулево = Булево(ЗначениеПараметра);
				ПараметрыЗапроса.Вставить(ЗапрашиваемыйПараметр.Имя, ЗначениеБулево);
				Продолжить;
			Исключение
				ВызватьИсключениеВалидация(СтрШаблон("failed to convert value [%1] to boolean", ЗначениеПараметра));
			КонецПопытки;
		ИначеЕсли Тип = ФабрикаТипов.Число Тогда
			Попытка
				ЗначениеЧислом = Число(ЗначениеПараметра);
				ПараметрыЗапроса.Вставить(ЗапрашиваемыйПараметр.Имя, ЗначениеЧислом);
				Продолжить;
			Исключение
				ВызватьИсключениеВалидация(СтрШаблон("failed to convert value [%1] to number", ЗначениеПараметра));
			КонецПопытки;
		ИначеЕсли Тип = ФабрикаТипов.Дата Тогда
			Попытка
				Дата = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.w3.org/2001/XMLSchema", "date"), ЗначениеПараметра);
				ПараметрыЗапроса.Вставить(ЗапрашиваемыйПараметр.Имя, Дата.Значение);
				Продолжить;
			Исключение
				ВызватьИсключениеВалидация(СтрШаблон("value [%1] is not date", ЗначениеПараметра));
			КонецПопытки;
		ИначеЕсли Тип = ФабрикаТипов.ДатаВремя Тогда
			Попытка
				Дата = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.w3.org/2001/XMLSchema", "dateTime"), ЗначениеПараметра);
				ПараметрыЗапроса.Вставить(ЗапрашиваемыйПараметр.Имя, Дата.Значение);
				Продолжить;
			Исключение
				ВызватьИсключениеВалидация(СтрШаблон("value [%1] is not dateTime", ЗначениеПараметра));
			КонецПопытки;
		ИначеЕсли Тип = ФабрикаТипов.Гуид Тогда
			Попытка
				ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("https://github.com/Daabramov/1c-http-framework", "guid"), ЗначениеПараметра);			
				ПараметрыЗапроса.Вставить(ЗапрашиваемыйПараметр.Имя, ЗначениеПараметра);
			Исключение
				ВызватьИсключениеВалидация(СтрШаблон("value [%1] is not guid", ЗначениеПараметра));
			КонецПопытки;
			
			Если ЗапрашиваемыйПараметр.СсылочныйТип <> Неопределено Тогда
				ЗначениеПараметра = СсылкаПоИдентификатору(ЗапрашиваемыйПараметр.СсылочныйТип, ЗначениеПараметра);
				ПараметрыЗапроса.Вставить(ЗапрашиваемыйПараметр.Имя, ЗначениеПараметра);
			КонецЕсли;
			Продолжить;
		ИначеЕсли Тип = ФабрикаТипов.Строка Тогда
			Продолжить;
		КонецЕсли;
		
		ТипПрочитан = Ложь;
		
		бф_СервисыОбщееПереопределяемый.ПриЧтенииПараметраЗапроса(ЗапрашиваемыйПараметр, ЗначениеПараметра, ТипПрочитан);
		
		Если ТипПрочитан Тогда 
			ПараметрыЗапроса.Вставить(ЗапрашиваемыйПараметр.Имя, ЗначениеПараметра);
			Продолжить;
		КонецЕсли;
					
		ВызватьИсключение СтрШаблон("Неподдерживаемый тип параметра %1 для %2", Тип, ЗапрашиваемыйПараметр.Имя);
	КонецЦикла;
	
	Возврат ПараметрыЗапроса;
	
КонецФункции

// Выполняет чтение тела запроса HTTP-сервиса, имеющее составное содержимое (multipart/form-data) и возвращает поля
// этого содержимого в виде соответствия. В качестве ключа используется имя поля.
//
// Параметры:
//  Запрос - HTTPСервисЗапрос - запрос, полученный HTTP-сервисом.
// 
// Возвращаемое значение:
//  Соответствие из КлючИЗначение - соответствие, содержащее описание полей составного содержимого:
//  * Ключ - Строка - В качестве ключа используется имя поля
//  * Значение - см. ПолеСоставногоСодержимогоЗапроса
//
// Ссылки: 
// https://infostart.ru/public/1277790/
Функция ПрочитатьСоставноеСодержимоеЗапроса(Запрос) Экспорт
	ПоляЗапроса = Новый Соответствие;

	РазделительПолей = ПолучитьРазделитьПолейСоставногоСодержимого(Запрос);
	ОкончаниеПолей = "--";

	ТелоЗапроса = Запрос.ПолучитьТелоКакПоток();
	ЧтениеДанных = Новый ЧтениеДанных(ТелоЗапроса);

	ЕстьДанные = Истина;
	Пока ЕстьДанные Цикл

		//@skip-check invocation-parameter-type-intersect
		РезультатЧтения = ЧтениеДанных.ПрочитатьДо(РазделительПолей);
		ЕстьДанные = РезультатЧтения.МаркерНайден;

		Если ЕстьДанные Тогда
			Строка = ЧтениеДанных.ПрочитатьСтроку();
			ЕстьДанные = (Строка <> ОкончаниеПолей);
		КонецЕсли;

		Если РезультатЧтения.Размер = 0 Тогда
			Продолжить;
		КонецЕсли;

		Поток = РезультатЧтения.ОткрытьПотокДляЧтения();

		Поле = ПрочитатьПолеСоставногоСодержимогоИзПотока(Поток);
		ПоляЗапроса.Вставить(Поле.Имя, Поле);

		Поток.Закрыть();

	КонецЦикла;

	ЧтениеДанных.Закрыть();
	ТелоЗапроса.Закрыть();

	Возврат ПоляЗапроса;
КонецФункции

#КонецОбласти

#Область Вспомогательные

// Ссылка по идентификатору.
// 
// Параметры:
//  Тип - Тип - Тип объекта получаемой ссылки
//  Ид - Строка - Уникальный идентификатор
//  РазрешатьПустуюСсылку - Булево - Разрешить пустую ссылку, тогда возвращается пустая ссылка
//  
// Возвращаемое значение:
//  ЛюбаяСсылка - Ссылка по идентификатору
Функция СсылкаПоИдентификатору(Тип, Ид, РазрешатьПустуюСсылку = Ложь) Экспорт
	
	Ссылка = XMLЗначение(Тип, Ид); // ЛюбаяСсылка
	
	Если РазрешатьПустуюСсылку И (Ид = ПустойИдентификатор() Или Не ЗначениеЗаполнено(Ид)) Тогда
		Возврат Новый(Тип);
	КонецЕсли;

	Если Не бф_ХТТПСлужебный.СсылкаСуществует(Ссылка) Тогда
		ВызватьИсключениеВалидация(СтрШаблон("object (type: %1) with guid [%2] does not exist", Тип, Ид));
	КонецЕсли;
	
	Возврат Ссылка;

КонецФункции	

#КонецОбласти

#Область Конструкторы

// Новый параметр запроса.
// 
// Параметры:
//  Имя - Строка - Имя
//  Тип - Строка - Описание типа строкой, см. бф_ФабрикаХТТП.ТипыПараметровЗапроса
//  Обязательный - Булево - Признак обязательности параметра
//  СсылочныйТип - Тип - Ссылочный тип, используется для автоматического преобразования. Используется только при Тип = Гуид
// 
// Возвращаемое значение:
//  Структура - Новый параметр запроса:
// * Имя - Строка
// * Обязательный - Булево
// * Тип - см. НовыйПараметрЗапроса.Тип
// * ВозможныеЗначения - Массив из Строка - возможные значения строк указывать в нижнем регистре
// * СсылочныйТип - Неопределено,Тип - Ссылочный тип
Функция НовыйПараметрЗапроса(Имя, Тип = Неопределено, Обязательный = Ложь, СсылочныйТип = Неопределено) Экспорт
	
	Если ТипЗнч(Тип) = Тип("Неопределено") Тогда
		_Тип = бф_ФабрикаХТТП.ТипыПараметровЗапроса().Строка; 
	Иначе
		_Тип = Тип;
	КонецЕсли;
	
	Параметр = Новый Структура();
	Параметр.Вставить("Имя", Имя);
	Параметр.Вставить("Обязательный", Обязательный);
	Параметр.Вставить("Тип", _Тип);
	Параметр.Вставить("СсылочныйТип", СсылочныйТип);
	Параметр.Вставить("ВозможныеЗначения", Новый Массив());
	
	Возврат Параметр;
	
КонецФункции

// Вспомогательный метод для группового создания описания параметров для чтения из запроса ХТТП
// 
// Параметры:
//  Пар1 - см. НовыйПараметрЗапроса
//  Пар2 - см. НовыйПараметрЗапроса
//  Пар3 - см. НовыйПараметрЗапроса
//  Пар4 - см. НовыйПараметрЗапроса
//  Пар5 - см. НовыйПараметрЗапроса
//  Пар6 - см. НовыйПараметрЗапроса
//  Пар7 - см. НовыйПараметрЗапроса
//  Пар8 - см. НовыйПараметрЗапроса
//  Пар9 - см. НовыйПараметрЗапроса
//  Пар10 - см. НовыйПараметрЗапроса
//  Пар11 - см. НовыйПараметрЗапроса
//  Пар12 - см. НовыйПараметрЗапроса
// 
// Возвращаемое значение:
//  Массив из см. НовыйПараметрЗапроса
//@skip-check method-too-many-params
Функция НовыйПараметрыЗапроса(Пар1 = Неопределено, Пар2 = Неопределено, Пар3 = Неопределено, Пар4 = Неопределено, Пар5 = Неопределено, Пар6 = Неопределено, Пар7 = Неопределено,
		Пар8 = Неопределено, Пар9 = Неопределено, Пар10 = Неопределено, Пар11 = Неопределено, Пар12 = Неопределено) Экспорт 
		
	Результат = Новый Массив; // Массив из см. НовыйПараметрЗапроса
	
	ДобавитьОписаниеПараметраЗапросаВКоллекцию(Результат, Пар1);
	ДобавитьОписаниеПараметраЗапросаВКоллекцию(Результат, Пар2);
	ДобавитьОписаниеПараметраЗапросаВКоллекцию(Результат, Пар3);
	ДобавитьОписаниеПараметраЗапросаВКоллекцию(Результат, Пар4);
	ДобавитьОписаниеПараметраЗапросаВКоллекцию(Результат, Пар5);
	ДобавитьОписаниеПараметраЗапросаВКоллекцию(Результат, Пар6);
	ДобавитьОписаниеПараметраЗапросаВКоллекцию(Результат, Пар7);
	ДобавитьОписаниеПараметраЗапросаВКоллекцию(Результат, Пар8);
	ДобавитьОписаниеПараметраЗапросаВКоллекцию(Результат, Пар9);
	ДобавитьОписаниеПараметраЗапросаВКоллекцию(Результат, Пар10);
	ДобавитьОписаниеПараметраЗапросаВКоллекцию(Результат, Пар11);
	ДобавитьОписаниеПараметраЗапросаВКоллекцию(Результат, Пар12);
	
	Возврат Результат;	
		
КонецФункции
#КонецОбласти

#Область ФормированиеОтветов

// Ответ из объекта.
// 
// Параметры:
//  Объект - Структура,Соответствие,Массив,ФиксированнаяКоллекция
//  Код - Число - Код
//  ДопПараметры - Структура:
//  * ПараметрыПреобразованияJson - см. бф_КоннекторХТТП.ПараметрыПреобразованияJSONПоУмолчанию
//  * ПараметрыЗаписиJson - см. бф_КоннекторХТТП.ПараметрыЗаписиJSONПоУмолчанию
// 
// Возвращаемое значение:
//  HTTPСервисОтвет - Ответ из объекта
//@skip-check doc-comment-collection-item-type
Функция ОтветИзОбъекта(Объект, Код = 200, ДопПараметры = Неопределено) Экспорт
	//@skip-check invocation-parameter-type-intersect
	СтрокаJson = бф_КоннекторХТТП.ОбъектВJson(
		Объект,
		бф_ХТТПСлужебный.ЗначениеПоКлючу(ДопПараметры, "ПараметрыПреобразованияJson"),
		бф_ХТТПСлужебный.ЗначениеПоКлючу(ДопПараметры, "ПараметрыЗаписиJson")
	);
	Ответ = ОтветИзСтроки(СтрокаJson, Код);
	Ответ.Заголовки.Вставить("Content-Type", "application/json");
	Возврат Ответ;
КонецФункции

// Ответ из строки.
// 
// Параметры:
//  ТелоОтвета - Строка - Тело ответа
//  Код - Число - Код
// 
// Возвращаемое значение:
//  HTTPСервисОтвет - Ответ из строка
Функция ОтветИзСтроки(ТелоОтвета, Код = 200) Экспорт
	Ответ = ОтветПоКоду(Код);
	Ответ.УстановитьТелоИзСтроки(ТелоОтвета);
	Возврат Ответ;
КонецФункции

// Ответ из двоичных данных.
// 
// Параметры:
//  Данные - ДвоичныеДанные - Данные
//  Код - Число - Код
// 
// Возвращаемое значение:
//  HTTPСервисОтвет - Ответ из двоичных данных
Функция ОтветИзДвоичныхДанных(Данные, Код = 200) Экспорт
	Ответ = ОтветПоКоду(Код);
	Ответ.УстановитьТелоИзДвоичныхДанных(Данные);
	Ответ.Заголовки.Вставить("Content-Type", "application/octet-stream");
	Возврат Ответ;
КонецФункции

// Ответ по коду.
// 
// Параметры:
//  Код - Число - Код
// 
// Возвращаемое значение:
//  HTTPСервисОтвет - Ответ по коду
Функция ОтветПоКоду(Код = 200) Экспорт
	Ответ = Новый HTTPСервисОтвет(Код);
	Возврат Ответ;
КонецФункции

// Плохой запрос (400).
// 
// Параметры:
//  Сообщение - Строка - Тест ошибки проверки
//  Код - Число - Код ХТТП ответа
// 
// Возвращаемое значение:
//  HTTPСервисОтвет - Новый плохой запрос
Функция ПлохойЗапрос(Сообщение, Код = 400) Экспорт
	
	Возврат ОтветИзСтроки(Сообщение, Код);
	
КонецФункции

// Ошибка доступа (403).
// 
// Параметры:
//  Сообщение - Строка - Тест ошибки проверки
//  Код - Число - Код ХТТП ответа
// 
// Возвращаемое значение:
//  HTTPСервисОтвет - Новый плохой запрос
Функция ОшибкаДоступа(Сообщение, Код = 403) Экспорт
	
	Возврат ОтветИзСтроки(Сообщение, Код);
	
КонецФункции

// Ошибка Сервиса (500).
// 
// Параметры:
//  Сообщение - Строка - Тест ошибки проверки
//  ИдентификатораОшибки - Строка - Идентификатор ошибки
//  Код - Число - Код ХТТП ответа
// 
// Возвращаемое значение:
//  HTTPСервисОтвет - Новый плохой запрос
Функция ОшибкаСервера(Сообщение, Код = 500) Экспорт
	Возврат ОтветИзСтроки(Сообщение, Код);
КонецФункции
#КонецОбласти

#Область Исключения

// Вызвать исключение проверки.
// 
// Параметры:
//  Заголовок - Строка - Заголовок ошибки проверки
//  КодОшибки - Строка - Код ошибки проверки. Например, "https://example.net/validation-error"
//  ПодробноеОписание - Строка - Подробное представление ошибки
//  ДопИнформация - Структура - Дополнительная информация
Процедура ВызватьИсключениеПроверки(Заголовок, КодОшибки = Неопределено, ПодробноеОписание = Неопределено,
	ДопИнформация = Неопределено) Экспорт
	//@skip-check structure-consructor-too-many-keys
	ОписаниеОшибки = Новый Структура("Заголовок", Заголовок);
	Если КодОшибки <> Неопределено Тогда
		ОписаниеОшибки.Вставить("КодОшибки", КодОшибки);
	КонецЕсли;
	Если ПодробноеОписание <> Неопределено Тогда
		ОписаниеОшибки.Вставить("ПодробноеОписание", ПодробноеОписание);
	КонецЕсли;
	Если ДопИнформация <> Неопределено Тогда
		ОписаниеОшибки.Вставить("ДопИнформация", ДопИнформация);
	КонецЕсли;

	Ошибка = СтрШаблон(
		"%1%2",
		бф_ОбработкаЗапросовПовтИсп.БазовыйКодОшибкиПроверки(),
		ЗначениеВСтрокуВнутр(ОписаниеОшибки)
	);
	ВызватьИсключение Ошибка;
КонецПроцедуры

// Вызвать исключение валидация.
// 
// Параметры:
//  ПодробноеОписание - Строка
Процедура ВызватьИсключениеВалидация(ПодробноеОписание) Экспорт
	//@skip-check bsl-nstr-string-literal-format
	ВызватьИсключениеПроверки(
		НСтр("en = 'Data validation error';ru = 'Ошибка валидации данных'"),
		бф_ФабрикаХТТП.КодыТиповОшибок().ОшибкаВалидации,
		ПодробноеОписание
	);
КонецПроцедуры

// Вызвать исключение доступа
// 
// Параметры:
//  Сообщение - Строка - Передаваемое сообщение ошибки доступа
Процедура ВызватьИсключениеДоступа(Сообщение) Экспорт
	
	//@skip-check bsl-nstr-string-literal-format
	ОписаниеОшибки = Новый Структура(
		"Заголовок,КодОшибки,ПодробноеОписание", 
		НСтр("en = 'Access denied';ru = 'Ошибка доступа'"),
		бф_ФабрикаХТТП.КодыТиповОшибок().ОшибкаДоступа,
		Сообщение
	);
	Ошибка = СтрШаблон(
		"%1%2",
		бф_ОбработкаЗапросовПовтИсп.БазовыйКодОшибкиДоступа(),
		ЗначениеВСтрокуВнутр(ОписаниеОшибки)
	);
	ВызватьИсключение Ошибка;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЧтениеJsonИзИсточника(Источник, Кодировка)
	ЧтениеJson = Новый ЧтениеJSON;
	Если ТипЗнч(Источник) = Тип("HTTPСервисЗапрос") Тогда
		Поток = Источник.ПолучитьТелоКакПоток();
		Если Поток.Размер() = 0 Тогда
			ВызватьИсключениеВалидация("body is empty");
		КонецЕсли;
		ЧтениеJson.ОткрытьПоток(Поток, Кодировка);
	ИначеЕсли ТипЗнч(Источник) = Тип("Поток") Тогда
		Если Источник.Размер() = 0 Тогда
			ВызватьИсключениеВалидация("body is empty");
		КонецЕсли;
		ЧтениеJson.ОткрытьПоток(Источник, Кодировка);
	ИначеЕсли ТипЗнч(Источник) = Тип("ДвоичныеДанные") Тогда
		Если Источник.Размер() = 0 Тогда
			ВызватьИсключениеВалидация("body is empty");
		КонецЕсли;
		ЧтениеJson.УстановитьСтроку(ПолучитьСтрокуИзДвоичныхДанных(Источник, Кодировка));
	ИначеЕсли ТипЗнч(Источник) = Тип("Строка") Тогда
		Если Не ЗначениеЗаполнено(Источник) Тогда
			ВызватьИсключениеВалидация("body is empty");
		КонецЕсли;
		ЧтениеJson.УстановитьСтроку(Источник);
	Иначе
		ВызватьИсключение "Недопустимый тип данных";
	КонецЕсли;
	Возврат ЧтениеJson
КонецФункции

// Выполняет чтение поля составного содержимого из потока, полученного из тела запроса.
//
// Параметры:
//  Поток - Поток - поток, содержащий данные поля составного содержимого.
// 
// Возвращаемое значение:
//  Структура - см. ПолеСоставногоСодержимогоЗапроса
//
Функция ПрочитатьПолеСоставногоСодержимогоИзПотока(Поток)
	
	Поле = ПолеСоставногоСодержимогоЗапроса();
	
	ЧтениеДанных = Новый ЧтениеДанных(Поток);
	
	ЭтоСодержимое = Ложь;
	Пока Не ЭтоСодержимое Цикл
		Строка = ЧтениеДанных.ПрочитатьСтроку();
		
		Если ЗначениеЗаполнено(Строка) Тогда
			ОбработатьЗаголовокСоставногоСодержимого(Поле, Строка);
		Иначе
			// Пустая строка является разделителем заголовков и содержимого поля.
			ЭтоСодержимое = Истина;
		КонецЕсли; 
	КонецЦикла; 
	
	РезультатЧтения = ЧтениеДанных.Прочитать();
	
	Если РезультатЧтения.Размер > 0 Тогда
		
		ПотокСодержимого = РезультатЧтения.ОткрытьПотокДляЧтения();
		ЧтениеДанныхСодержимого = Новый ЧтениеДанных(ПотокСодержимого);
		
		ДвоичноеСодержимое = (Поле.ИмяФайла <> Неопределено);
		Если ДвоичноеСодержимое Тогда
			РазмерСодержимого = РезультатЧтения.Размер - 2; // Конечный разделитель строк (ВК + ПС) не нужен.
			РезультатЧтенияСодержимого = ЧтениеДанныхСодержимого.Прочитать(РазмерСодержимого);
			
			Поле.Содержимое = РезультатЧтенияСодержимого.ПолучитьДвоичныеДанные();
		Иначе
			Поле.Содержимое = ЧтениеДанныхСодержимого.ПрочитатьСимволы();
			
			// Конечный разделитель строк (ПС) не нужен (согласно RFC7578 разделителем строк является ВК + ПС, но 1С
			// конвертирует в ПС при чтении строк).
			Поле.Содержимое = Лев(Поле.Содержимое, СтрДлина(Поле.Содержимое) - 1);
		КонецЕсли; 
		
		ЧтениеДанныхСодержимого.Закрыть();
		ПотокСодержимого.Закрыть();
		
	КонецЕсли; 
	
	ЧтениеДанных.Закрыть();
	
	Возврат Поле;
	
КонецФункции 

// Обрабатывает строку заголовка поля составного содержимого (multipart/form-data) и заполняет свойства "Имя",
// "ИмяФайла" и "ТипСодержимого" (в зависимости от заголока) структуры, описывающей это поле.
//
// Параметры:
//  Поле - см. ПолеСоставногоСодержимогоЗапроса
//  ПолныйЗаголовок - Строка - полный заголовок поля составного содержимого. Например,
//                             Content-Disposition: form-data; name="file"; filename="image01.jpg"
//
Процедура ОбработатьЗаголовокСоставногоСодержимого(Поле, ПолныйЗаголовок)
	
	Поз = СтрНайти(ПолныйЗаголовок, ":");
	Заголовок = НРег(Лев(ПолныйЗаголовок, Поз - 1));
	
	Если Заголовок = "content-disposition" Тогда
		
		Поз = СтрНайти(ПолныйЗаголовок, ";");
		СвойстваЗаголовка = СокрЛ(Сред(ПолныйЗаголовок, Поз + 1));
		
		МассивСвойств = СтрРазделить(СвойстваЗаголовка, ";");
		Для каждого Свойство Из МассивСвойств Цикл
			
			КлючЗначение = СтрРазделить(СокрЛП(Свойство), "=");
			Ключ = НРег(СокрЛП(КлючЗначение[0]));
			Значение = УдалитьОбрамляющиеКавычкиИзСтроки(СокрЛП(КлючЗначение[1]));
			
			Если Ключ = "name" Тогда
				Поле.Имя = Значение;
			ИначеЕсли Ключ = "filename" Тогда
				Поле.ИмяФайла = Значение;
			КонецЕсли; 
			
		КонецЦикла;
		
	ИначеЕсли Заголовок = "content-type" Тогда
		
		Поле.ТипСодержимого = СокрЛ(Сред(ПолныйЗаголовок, Поз + 1));
		
	КонецЕсли; 
	
КонецПроцедуры 

// Возвращает инициализированную структуру, описывающую поле составного запроса.
// 
// Возвращаемое значение:
//  Структура - структура, описывающая поле составного содержимого запроса:
//    * Имя - Строка - имя поля (name).
//    * ИмяФайла - Строка - имя файла (filename). Если имя файла указано, то содержимое является двоичными данными.
//    * ТипСодержимого - Строка - тип содержимого, указанный в заголовке Content-Type поля. 
//                                Например: text/plain, image/jpeg и т.п. Может отсутствовать.
//    * Содержимое - Строка, ДвоичныеДанные - содержимое поля. Если указано имя файла, то содержит двоичные данные,
//                                            иначе Строка.
//
//@skip-check constructor-function-return-section,structure-consructor-value-type,structure-consructor-too-many-keys
Функция ПолеСоставногоСодержимогоЗапроса()
	
	Возврат Новый Структура("Имя, ИмяФайла, ТипСодержимого, Содержимое");
	
КонецФункции

// Получает разделитель (boundary) составного содержимого (multipart/form-data) из заголовка Content-Type.
// Если значение заголовка Content-Type не равно multipart/form-data или свойство boundary не указано, то будет вызвано
// исключение.
//
// Параметры:
//  Запрос - HTTPСервисЗапрос - запрос, полученный HTTP-сервисом.
// 
// Возвращаемое значение:
//  Строка - значение свойства boundary заголовка Content-Type для multipart/form-data.
//
Функция ПолучитьРазделитьПолейСоставногоСодержимого(Запрос)
	
	ПолныйТипСодержимого = Запрос.Заголовки["Content-Type"]; // Строка
	
	Поз = СтрНайти(ПолныйТипСодержимого, ";");
	ТипСодержимого = НРег(?(Поз > 0, Лев(ПолныйТипСодержимого, Поз - 1), ПолныйТипСодержимого));
	
	Если ТипСодержимого <> "multipart/form-data" Тогда
		ВызватьИсключениеВалидация("The request value is not multipart content or the Content-Type header is incorrect");
	КонецЕсли; 
	
	Поз = СтрНайти(ПолныйТипСодержимого, "boundary", , Поз + 1);
	Если Поз = 0 Тогда
		ВызватьИсключениеВалидация("The boundary of the multipart content in the Content-Type header is not specified'");
	КонецЕсли; 
	
	Поз = СтрНайти(ПолныйТипСодержимого, "=", , Поз);
	Если Поз = 0 Тогда
		ВызватьИсключениеВалидация("The boundary value of the multipart content in the Content-Type header is not specified");
	КонецЕсли; 
	
	ПозНачалаРазделителя = Поз + 1;
	ПозОкончанияРазделителя = СтрНайти(ПолныйТипСодержимого, ";", , ПозНачалаРазделителя);
	
	Если ПозОкончанияРазделителя = 0 Тогда
		РазделительПолей = СокрЛП(Сред(ПолныйТипСодержимого, ПозНачалаРазделителя));
	Иначе
		КоличествоСимволов = ПозОкончанияРазделителя - ПозНачалаРазделителя;
		РазделительПолей = СокрЛП(Сред(ПолныйТипСодержимого, ПозНачалаРазделителя, КоличествоСимволов));
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(РазделительПолей) Тогда
		ВызватьИсключениеВалидация("The boundary value of the multipart content in the Content-Type header is not specified");
	КонецЕсли; 
	
	Возврат "--" + РазделительПолей;
	
КонецФункции 

// Если строка указана в кавычках, то выполняет удаление этих кавычек в начале и конце строки.
// Например, строка "Пример" будет преобразована в Пример (без кавычек).
//
// Параметры:
//  Строка - Строка - строка, указанная в кавычках
// 
// Возвращаемое значение:
//  Строка - строка, переданная в параметре без кавычек.
//
Функция УдалитьОбрамляющиеКавычкиИзСтроки(Строка)
	
	ПервыйСимвол = Лев(Строка, 1);
	ПоследнийСимвол = Прав(Строка, 1);
	
	СтрокаВКавычках = (ПервыйСимвол = """" И ПоследнийСимвол = """");
	
	Возврат ?(СтрокаВКавычках,
				Сред(Строка, 2, СтрДлина(Строка) - 2),
				Строка);
	
КонецФункции 

Функция ПустойИдентификатор()
	Возврат "00000000-0000-0000-0000-000000000000";	
КонецФункции

Процедура ДобавитьОписаниеПараметраЗапросаВКоллекцию(ПараметрыЗапроса, ОписаниеПараметра)
	Если ОписаниеПараметра <> Неопределено Тогда
		ПараметрыЗапроса.Добавить(ОписаниеПараметра);
	КонецЕсли;
КонецПроцедуры 

#КонецОбласти
