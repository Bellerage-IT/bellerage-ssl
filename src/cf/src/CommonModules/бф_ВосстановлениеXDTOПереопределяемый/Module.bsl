// @strict-types

#Область ПрограммныйИнтерфейс

//@skip-check module-empty-method
// Восстановить значение XDTO.
// 
// Параметры:
//  Результат - Произвольный - Данные для возврата
//  Свойство - Строка - Имя свойства
//  Тип - ТипОбъектаXDTO,ТипЗначенияXDTO - Тип XDTO
//  Значение - Произвольный - Исходное значение
//  ДопПараметры - Неопределено,Структура - Доп параметры
// 
//  Произвольный
Процедура ВосстановитьЗначениеXDTO(Результат, Свойство, Тип, Значение, ДопПараметры) Экспорт

КонецПроцедуры

//@skip-check module-empty-method
// Конвертировать из формата.
// 
// Параметры:
//  Результат - Произвольный - Вычисленные ранее результат
//  ОбъектXDTO - ОбъектXDTO,СписокXDTO - Прочитанные данные в объект или список XDTO
//  ФункцииВосстановления - см. бф_ВосстановлениеXDTO.НовыеПараметрыВосстановления
//  ДопПараметры - Неопределено, Структура - Доп параметры
//  ИмяСвойстваСписка - Строка - Имя свойства для поиска функции восстановления элементов списка
// 
Процедура КонвертироватьИзФормата(Результат, ОбъектXDTO, ФункцииВосстановления, ДопПараметры, ИмяСвойстваСписка) Экспорт
	
КонецПроцедуры

#КонецОбласти
