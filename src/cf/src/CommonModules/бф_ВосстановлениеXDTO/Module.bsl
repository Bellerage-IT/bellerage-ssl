//@strict-types
//@skip-check doc-comment-collection-item-type

#Область ПрограммныйИнтерфейс

// Восстановить значение XDTO.
// 
// Параметры:
//  Свойство - Строка - Имя свойства 
//  Тип - ТипОбъектаXDTO,ТипЗначенияXDTO - Тип XDTO
//  Значение - Произвольный - Исходное значение
//  ДопПараметры - Неопределено,Структура - Доп параметры
// 
// Возвращаемое значение:
//  Произвольный
Функция ВосстановитьЗначениеXDTO(Свойство, Тип, Значение, ДопПараметры) Экспорт
	Результат = Значение;
	бф_ВосстановлениеXDTOПереопределяемый.ВосстановитьЗначениеXDTO(Результат, Свойство, Тип, Значение, ДопПараметры);
	Возврат Значение;
КонецФункции

// Конвертировать из формата.
// 
// Параметры:
//  ОбъектXDTO - ОбъектXDTO,СписокXDTO - Прочитанные данные в объект или список XDTO
//  ФункцииВосстановления - см. НовыеПараметрыВосстановления
//  ДопПараметры - Неопределено, Структура - Доп параметры
//  ИмяСвойстваСписка - Строка - Имя свойства для поиска функции восстановления элементов списка
// 
// Возвращаемое значение:
//  - Соответствие из КлючИЗначение:
//	* Ключ - Произвольный
//	* Значение - Число,Строка,Булево,Дата,Соответствие,Массив
//	- Массив из Произвольный
Функция КонвертироватьИзФормата(ОбъектXDTO, ФункцииВосстановления = Неопределено,
	ДопПараметры = Неопределено, ИмяСвойстваСписка = Неопределено) Экспорт
	
	ТипОбъекта = ТипЗнч(ОбъектXDTO);
	Если ТипОбъекта = Тип("ОбъектXDTO") Тогда
		Результат = ВосстановитьОбъектXDTO(ОбъектXDTO, ФункцииВосстановления, ДопПараметры);
	ИначеЕсли ТипОбъекта = Тип("СписокXDTO") Тогда
		//@skip-check statement-type-change
		Результат = ВосстановитьСписокXDTO(ОбъектXDTO, ФункцииВосстановления, ДопПараметры, ИмяСвойстваСписка);
	Иначе
		ВызватьИсключение "Неподдерживаемый тип для конвертации";
	КонецЕсли;
	
	бф_ВосстановлениеXDTOПереопределяемый.КонвертироватьИзФормата(
		Результат,
		ОбъектXDTO,
		ФункцииВосстановления,
		ДопПараметры,
		ИмяСвойстваСписка
	);
	Возврат Результат;
	
	
КонецФункции

// Новые параметры восстановления.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Новые параметры восстановления:
// * СвойствоИсходное - Строка - Имя исходного свойства
// * ИмяСвойства - Строка - имя желаемоего свойства
// * ФункцияВосстановленияЗначения - Строка - Имя функции восстановления. Например Общее.ВосстановитьСтроку
Функция НовыеПараметрыВосстановления() Экспорт
	Результат = Новый ТаблицаЗначений();
	Результат.Колонки.Добавить("СвойствоИсходное", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ИмяСвойства", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("ФункцияВосстановленияЗначения", Новый ОписаниеТипов("Строка"));
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Восстановить список XDTO.
// 
// Параметры:
//  СписокXDTO - СписокXDTO - Список XDTO
//  ФункцииВосстановления - см. НовыеПараметрыВосстановления
//  ДопПараметры - Неопределено, Структура - Доп параметры
//  ИмяСвойства - Строка,Неопределено - Имя свойства для восстановления элементов списка
// 
// Возвращаемое значение:
//  Массив из Произвольный
Функция ВосстановитьСписокXDTO(СписокXDTO, ФункцииВосстановления, ДопПараметры, ИмяСвойства = Неопределено)
	Результат = Новый Массив(); // Массив из см. КонвертироватьИзФормата
	
	Для Каждого Строка Из СписокXDTO Цикл
		Если ТипЗнч(Строка) = Тип("ОбъектXDTO") Или ТипЗнч(Строка) = Тип("СписокXDTO") Тогда
			Результат.Добавить(КонвертироватьИзФормата(Строка, ФункцииВосстановления, ДопПараметры));
		Иначе
			СтрокаФункцииВосстановления = СтрокаВосстановления(ИмяСвойства, ФункцииВосстановления);
				
			Если СтрокаФункцииВосстановления <> Неопределено 
				И ЗначениеЗаполнено(СтрокаФункцииВосстановления.ФункцияВосстановленияЗначения) Тогда
				УстановитьБезопасныйРежим(Истина);
				Значение = Вычислить(
					СтрокаФункцииВосстановления.ФункцияВосстановленияЗначения + "(Строка, ДопПараметры)"
				); // см. КонвертироватьИзФормата
				Результат.Добавить(Значение);
				УстановитьБезопасныйРежим(Ложь);
			Иначе
				//@skip-check invocation-parameter-type-intersect
				Результат.Добавить(Строка);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Восстановить объект XDTO.
// 
// Параметры:
//  ОбъектXDTO - ОбъектXDTO - Исходный объект
//  ФункцииВосстановления - см. НовыеПараметрыВосстановления
//  ДопПараметры - Структура - доп папарметры
// 
// Возвращаемое значение:
//  Соответствие из КлючИЗначение - Восстановленный объект XDTO:
// * Ключ - Строка
// * Значение - Произвольный
Функция ВосстановитьОбъектXDTO(ОбъектXDTO, ФункцииВосстановления, ДопПараметры)
	
	Результат = Новый Соответствие();
	
	Для Каждого Свойство Из ОбъектXDTO.Свойства() Цикл
		
		ИмяСвойства = Свойство.Имя;
		ТребуетсяКонвертация = ТипЗнч(ОбъектXDTO[ИмяСвойства]) = Тип("ОбъектXDTO") 
								Или ТипЗнч(ОбъектXDTO[ИмяСвойства]) = Тип("СписокXDTO");									
		
		Значение = ?(
			ТребуетсяКонвертация,
			КонвертироватьИзФормата(
				ОбъектXDTO[ИмяСвойства],
				ФункцииВосстановления,
				ДопПараметры,
				ИмяСвойства
			),
			ОбъектXDTO[ИмяСвойства]
		); // Произвольный
		
		Если НЕ ТребуетсяКонвертация Тогда
			ОбработатьВосстановлениеЗначения(ФункцииВосстановления, Значение, ИмяСвойства, ДопПараметры);
		КонецЕсли;
		
		ОбработатьПереименование(ФункцииВосстановления, ИмяСвойства, ДопПараметры);
		
		Результат.Вставить(ИмяСвойства, Значение);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ОбработатьПереименование(ФункцииВосстановления, ИмяСвойства, ДопПараметры)

	СтрокаФункцийВосстановления = СтрокаВосстановления(ИмяСвойства, ФункцииВосстановления);

	Если СтрокаФункцийВосстановления = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаФункцийВосстановления.ИмяСвойства) Тогда
		ИмяСвойства = СтрокаФункцийВосстановления.ИмяСвойства;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработатьВосстановлениеЗначения(ФункцииВосстановления, Значение, ИмяСвойства, ДопПараметры)
	
	СтрокаФункцийВосстановления = СтрокаВосстановления(ИмяСвойства, ФункцииВосстановления);

	Если СтрокаФункцийВосстановления = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтрокаФункцийВосстановления.ФункцияВосстановленияЗначения) Тогда
		УстановитьБезопасныйРежим(Истина);
		Значение = Вычислить(СтрокаФункцийВосстановления.ФункцияВосстановленияЗначения + "(Значение, ДопПараметры)");
		УстановитьБезопасныйРежим(Ложь);
	КонецЕсли;
		
КонецПроцедуры

Функция СтрокаВосстановления(ИмяСвойства, ФункцииВосстановления)
	
	Если ФункцииВосстановления = Неопределено Или ИмяСвойства = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	СтрокиФункцийВосстановления = ФункцииВосстановления.НайтиСтроки(Новый Структура("СвойствоИсходное", ИмяСвойства));
	
	Если СтрокиФункцийВосстановления.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат СтрокиФункцийВосстановления[0];
	
КонецФункции

#КонецОбласти
