import 'dart:async';
import 'dart:io'; // Для работы с путями файлов
import 'package:path/path.dart'; // Для работы с путями
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models/flower.dart';

class DatabaseHelper {
  // Создание экземпляра базы данных
  static Database? _database;

  // Функция для открытия базы данных
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  // Инициализация базы данных
  _initDatabase() async {
    // Получаем путь к папке для хранения базы данных на устройстве
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String newDbPath = join(documentsDirectory.path, 'bloomix.sqlite3');

    // Открываем или создаем базу данных
    return await openDatabase(
      newDbPath,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  _onCreate(Database db, int version) async {
    // Создаем таблицы
    await db.execute('''
          CREATE TABLE User (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    profile_img TEXT
);
        ''');

    await db.execute('''
    CREATE TABLE Category (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL
);
  ''');

    await db.execute('''
    CREATE TABLE Selection (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    icon TEXT
);
  ''');

    await db.execute('''
    CREATE TABLE Flower (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    cost INTEGER NOT NULL,
    composition TEXT,
    image TEXT,
    category_id TEXT,
    selection_id TEXT,
    legend TEXT,
    FOREIGN KEY (category_id) REFERENCES Category(id),
    FOREIGN KEY (selection_id) REFERENCES Selection(id)
);
  ''');

    await db.execute('''
    CREATE TABLE Cart (
    user_id TEXT NOT NULL,
    flower_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (user_id, flower_id),
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (flower_id) REFERENCES Flower(id) ON DELETE CASCADE
);
  ''');

    await db.execute('''
    CREATE TABLE Favorites (
    user_id TEXT NOT NULL,
    flower_id TEXT NOT NULL,
    PRIMARY KEY (user_id, flower_id),
    FOREIGN KEY (user_id) REFERENCES User(id) ON DELETE CASCADE,
    FOREIGN KEY (flower_id) REFERENCES Flower(id) ON DELETE CASCADE
);
  ''');

    await _insertInitialData(db);
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Переход на версию 2
      await db.execute('ALTER TABLE Selection ADD COLUMN icon TEXT');
    }
    if (oldVersion < 3) {
      // Переход на версию 3
      await db.execute('ALTER TABLE Flower ADD COLUMN legend TEXT');
    }
    if (oldVersion < 4) {
      // Переход на версию 4
      await db.execute('ALTER TABLE Cart ADD COLUMN quantity INT');
    }
  }

  // Заполнение БД данными
  Future<void> _insertInitialData(Database db) async {
    // Заполнение таблицы Selection
    await db.execute('''
      INSERT INTO `Selection` (`id`,`name`,`icon`) VALUES ('6a1c2f20-4e02-4d8f-b7c8-123456789001','Свадебные','favorite');
    ''');
    await db.execute('''
     INSERT INTO `Selection` (`id`,`name`,`icon`) VALUES ('6a1c2f20-4e02-4d8f-b7c8-123456789002','8 марта','woman');
    ''');
    await db.execute('''
     INSERT INTO `Selection` (`id`,`name`,`icon`) VALUES ('6a1c2f20-4e02-4d8f-b7c8-123456789003','Популярные','trending_up');
    ''');
    await db.execute('''
     INSERT INTO `Selection` (`id`,`name`,`icon`) VALUES ('6a1c2f20-4e02-4d8f-b7c8-123456789004','Цветы в коробке','card_giftcard');
    ''');
    await db.execute('''
     INSERT INTO `Selection` (`id`,`name`,`icon`) VALUES ('6a1c2f20-4e02-4d8f-b7c8-123456789005','Для свидания','local_dining');
    ''');

    // Заполнение таблицы Category
    await db.execute('''
      INSERT INTO `Category` (`id`,`name`) VALUES ('550e8400-e29b-41d4-a716-446655440001','Ранункулюс');
    ''');
    await db.execute('''
     INSERT INTO `Category` (`id`,`name`) VALUES ('550e8400-e29b-41d4-a716-446655440002','Альстромерия');
    ''');
    await db.execute('''
     INSERT INTO `Category` (`id`,`name`) VALUES ('550e8400-e29b-41d4-a716-446655440003','Ромашка');
    ''');
    await db.execute('''
     INSERT INTO `Category` (`id`,`name`) VALUES ('550e8400-e29b-41d4-a716-446655440004','Роза');
    ''');
    await db.execute('''
     INSERT INTO `Category` (`id`,`name`) VALUES ('550e8400-e29b-41d4-a716-446655440005','Гипсофила');
    ''');


    // Заполнение таблицы Flower
    await db.execute('''
      INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456781','Букет невесты из ранункулюсов','Очаровательный букет невесты, в котором мягкость ранункулюсов контрастирует с текстурной зеленью эвкалипта.',7640,'Ранункулюс - 10, Эвкалипт - 6, Лента атласная - 1','https://i.pinimg.com/1200x/ab/51/b1/ab51b137b0a8a3e902c4951be09dac4d.jpg','550e8400-e29b-41d4-a716-446655440001','6a1c2f20-4e02-4d8f-b7c8-123456789001','При использовании цветов в букете невесты — они символизируют взаимность, гармонию двух людей, вступающих в брак. Белый цвет сам по себе означает чистоту, невинность, искренность');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456782','Ранункулюсы','Нежно-кремовые ранункулюсы, прекрасные и стойкие цветы.',6450,'Ранункулюсы - 7, Эвкалипт - 1, Дизайнерская упаковка - 3','https://content2.flowwow-images.com/data/flowers/1000x1000/30/1676202358_77551630.jpg','550e8400-e29b-41d4-a716-446655440001','6a1c2f20-4e02-4d8f-b7c8-123456789002','Значение ранункулюса зависит от цвета его лепестков. Обычно символика связана с позитивными смыслами. Кремовые и розовые сообщат получателю о влюбленности, симпатии и дружелюбии');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456783','Монобукет из ранункулюсов','Нежнейшие сортовые ранункулюсы. Премиум букет из редких весенних цветов.',6500,'Ранункулюс - 5, Эвкалипт - 5, Авторская упаковка - 1','https://content2.flowwow-images.com/data/flowers/1000x1000/06/1676202905_73160906.jpg','550e8400-e29b-41d4-a716-446655440001','6a1c2f20-4e02-4d8f-b7c8-123456789003','Белые ранункулюсы на языке цветов символизируют чистоту, невинность, искренность');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456784','Ранункулюсы в шляпной коробке','Стильная коробка с ранункулюсами.',8490,'Ранункулюс - 21','https://optim.tildacdn.com/tild6130-3138-4463-b738-353330353266/-/format/webp/ranunkulyus-14.jpg','550e8400-e29b-41d4-a716-446655440001','6a1c2f20-4e02-4d8f-b7c8-123456789004','Значение ранункулюса зависит от цвета его лепестков. Обычно символика связана с позитивными смыслами. Кремовые и розовые сообщат получателю о влюбленности, симпатии и дружелюбии');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456785','Ранункулюсы с эвкалиптом','Весенний букет, собранный только из белых ранункулюсов, покоряет своей нежностью и чистотой.',5400,'Ранункулюс - 5, Эвкалипт - 4, Дизайнерская упаковка - 1, Пистация - 3','https://storage.saastra.ru/main/__sized__/uploads/products/PAVELZHDAN00421-thumbnail-1500x1500-100.jpg','550e8400-e29b-41d4-a716-446655440001','6a1c2f20-4e02-4d8f-b7c8-123456789005','Белые ранункулюсы на языке цветов символизируют чистоту, невинность, искренность');
    ''');

    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456791','Букет невесты из белых альстромерий','Небольшой монобукет для невесты из 9 белых альстромерий с фисташкой под ленту. Нежный, очаровательный букет, который подойдет как на роспись, так и на само торжество. Стойкие соцветия альстромерий подойдут к любому образу и украсят праздник',7640,'Альстромерия белая - 9, Фисташка - 3, Лента атласная - 1','https://content2.flowwow-images.com/data/flowers/1000x1000/94/1695242668_59502894.jpg','550e8400-e29b-41d4-a716-446655440002','6a1c2f20-4e02-4d8f-b7c8-123456789001','Букет невесты из альстромерий символизируют преданность и искренность чувств возлюбленных. Также цветок ассоциируется со свежестью, невинностью, начинанием чего-то нового');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456792','Букет из альстромерий','Этот утонченный букет включает в себя 9 ярких и изящных цветов альстромерии, расположенных в прекрасной дизайнерской упаковке. Каждый цветок передает нежность и красоту, что делает этот букет идеальным подарком для особенного человека. Он подчеркнет вашу заботу и внимание к получателю и будет радостным украшением любого интерьера',5200,'Альстромерия - 9, Дизайнерская упаковка - 1','https://flawery.ru/image/thumb_610/products/236986/1266036_0.jpg','550e8400-e29b-41d4-a716-446655440002','6a1c2f20-4e02-4d8f-b7c8-123456789002','Белые альстромерии символизируют чистоту, невинность и искренность. Их часто выбирают для официальных событий и композиций');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456793','Букет из альстромерий','Букет из 11 прекрасных альстромерий — идеальное решение для тех, кто ценит нежность и изящество природы',6480,'Альстромерия - 11, Упаковка - 1','https://content2.flowwow-images.com/data/flowers/1000x1000/20/1721554610_50103220.jpg','550e8400-e29b-41d4-a716-446655440002','6a1c2f20-4e02-4d8f-b7c8-123456789003','Альстромерии символизируют радость, доброту и уважение к адресату букета');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456794','Альстромерия в коробке','Микс из альстромерий в шляпной коробке подойдут для любого праздника и без повода',3600,'Альстромерия - 7, Шляпная коробка - 1, Оазис - 1','https://flawery.ru/image/thumb_610/products/172893/1377283_0.jpg','550e8400-e29b-41d4-a716-446655440002','6a1c2f20-4e02-4d8f-b7c8-123456789004','Альстромерия символизирует дружбу, преданность и процветание. Её часто используют в букетах для выражения искренних чувств и пожеланий');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456795','Букет из сиреневых альстромерий','Прекрасное сочетание нежных альстромерий создает этот прекрасный букет. Каждый цветок выделяется своей яркой окраской и изящными лепестками. Букет стильно оформлен в упаковку, что делает его отличным подарком для любого повода',3860,'Альстромерия - 9, Упаковка - 1','https://flawery.ru/image/thumb_610/products/128169/1356720_0.jpg','550e8400-e29b-41d4-a716-446655440002','6a1c2f20-4e02-4d8f-b7c8-123456789005','Сиреневые альстромерии олицетворяют неповторимость и уникальность получателя. Такая насыщенная палитра подчёркивает преклонение перед красотой, умом, делами получательницы');
    ''');

    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456801','Букет невесты','Чудесный свадебный букетик из ромашек, подчеркнет легкость и изысканность вашей возлюбленной',5220,'Ромашка Камила - 17, Лента атласная - 1','https://content2.flowwow-images.com/data/flowers/1000x1000/98/1707297645_45455298.jpg','550e8400-e29b-41d4-a716-446655440003','6a1c2f20-4e02-4d8f-b7c8-123456789001','Букет невесты из ромашек может символизировать чистоту, невинность, юность и любовь. Белый цвет лепестков ромашек ассоциируется с чистотой, а жёлтая серединка — с домашним теплом и солнцем');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456802','Букет из ромашек','Букет комплимент из полевых ромашек. Красивый летний букет с чудесным ароматом станет отличным знаком внимания и подарит хорошее настроение',2300,'Ромашка - 5, Авторская упаковка - 1','https://flawery.ru/image/thumb_610/products/112498/1116236_0.jpg','550e8400-e29b-41d4-a716-446655440003','6a1c2f20-4e02-4d8f-b7c8-123456789002','В первую очередь её ассоциируют с солнышком из-за желтого центра. Растение воплощает нежность, невинность, чистота намерений, трепет, верность, тепло. Ромашка — это цветок для самых близких');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456803','Букет ромашек','Этот нежный и свежий букет включает в себя 11 изящных ромашек, которые символизируют нежность, чистоту и любовь. Они прекрасно дополнят любой интерьер и станут прекрасным подарком для любого повода - от романтического свидания до дня рождения. Ромашки являются классическими цветами, которые всегда ценятся за свою красоту и аромат. Этот букет будет радовать своего обладателя своей нежностью и светом',6600,'Ромашка - 11, Дизайнерская упаковка - 1','https://flawery.ru/image/thumb_610/products/292982/1361846_0.jpg','550e8400-e29b-41d4-a716-446655440003','6a1c2f20-4e02-4d8f-b7c8-123456789003','В первую очередь её ассоциируют с солнышком из-за желтого центра. Растение воплощает нежность, невинность, чистота намерений, трепет, верность, тепло. Ромашка — это цветок для самых близких');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456804','Коробка с полевыми ромашками','Композиция в крафтовой шляпной коробке из ароматных полевых ромашек. Красивый летний букет для девушек, которые любят полевые цветы. Не требует сложного ухода, достаточно поливать букет раз в несколько дней',3890,'Ромашка - 15, Шляпная коробка - 1','https://flawery.ru/image/thumb_610/products/112498/1287320_2.jpg','550e8400-e29b-41d4-a716-446655440003','6a1c2f20-4e02-4d8f-b7c8-123456789004','В первую очередь её ассоциируют с солнышком из-за желтого центра. Растение воплощает нежность, невинность, чистота намерений, трепет, верность, тепло. Ромашка — это цветок для самых близких');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456805','Букет из ромашек','Нежный букет из ромашек',2990,'Ромашка - 7, Лента - 1, Тишью - 2, Калька упаковка - 2','https://content2.flowwow-images.com/data/flowers/1000x1000/70/1717612893_83537270.jpg','550e8400-e29b-41d4-a716-446655440003','6a1c2f20-4e02-4d8f-b7c8-123456789005','В первую очередь её ассоциируют с солнышком из-за желтого центра. Растение воплощает нежность, невинность, чистота намерений, трепет, верность, тепло. Ромашка — это цветок для самых близких');
    ''');

    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456811','Букет невесты из розы Плайя Бланка','Букет невесты из красивой сортовой розы с пионовидным раскрытием. Роза отличается хорошей стойкостью',8400,'Роза Плайя Бланка - 21, Лента атласная - 1','https://content2.flowwow-images.com/data/flowers/1000x1000/79/1696139806_36930979.jpg','550e8400-e29b-41d4-a716-446655440004','6a1c2f20-4e02-4d8f-b7c8-123456789001','Белые розы символизируют верность, чистоту и невинность. Эти цветы также олицетворяют вечную любовь и новое начало');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456812','11 ароматных роз с эвкалиптом','Этот изысканный букет включает в себя нежные розы и ароматный эвкалипт цинерея. Красиво упакованный в дизайнерскую упаковку и украшенный лентой, он станет прекрасным подарком для особенного случая или просто чтобы порадовать близкого человека',3900,'Роза - 11, Эвкалипт цинерея - 7, Дизайнерская упаковка - 4, Лента атласная - 1','https://flawery.ru/image/thumb_610/products/173796/1280303_0.jpg','550e8400-e29b-41d4-a716-446655440004','6a1c2f20-4e02-4d8f-b7c8-123456789002','Воплощение пылкой любви и страсти между мужчиной и женщиной. Если вы хотите излить все свои пылкие чувства на любимую и уверены, что она к этому готова, без сомнений дарите красные розы');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456813','Кустовые розы','Этот великолепный букет состоит из 9 кустовых роз, которые символизируют нежность и любовь. Они упакованы с особой заботой и оформлены так, чтобы подчеркнуть их красоту и изящество. Этот букет будет прекрасным подарком для любого случая, от романтического свидания до праздника. Создайте незабываемый момент и порадуйте вашу любимую этим великолепным букетом роз',4650,'Роза кустовая - 9, Оформление - 1','https://flawery.ru/image/thumb_610/products/303290/1363141_0.jpg','550e8400-e29b-41d4-a716-446655440004','6a1c2f20-4e02-4d8f-b7c8-123456789003','Кустовые розы символизируют любовь, восхищение и признательность. Их часто дарят, чтобы показать человеку, как много он для вас значит или как вы цените его присутствие в вашей жизни');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456814','5 французских роз в шляпной коробке','Красивая композиция в шляпной коробке из ажурных, французских, розовых роз с эвкалиптом',3900,'Роза пинк мондиаль - 5, Эвкалипт - 3, Пленка матовая - 3, Шляпная коробка - 1, Оазис - 1','https://flawery.ru/image/thumb_1220/products/281750/1371800_0.jpg','550e8400-e29b-41d4-a716-446655440004','6a1c2f20-4e02-4d8f-b7c8-123456789004','Французская роза ассоциируется с утончённостью, грацией и любовью. Благодаря своей истории и культуре Франции, эти цветы стали символом романтики, изысканности и привязанности');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456815','15 пудровых роз с оформлением','15 нежных роз в стильном оформлении',6700,'Роза - 15, Тишью - 4, Пленка матовая - 3','https://flawery.ru/image/thumb_610/products/84277/1188572_0.jpg','550e8400-e29b-41d4-a716-446655440004','6a1c2f20-4e02-4d8f-b7c8-123456789005','Пудровые розы ассоциируются с нежностью, романтичностью и женственностью. Это цвет спокойных, мечтательных, гармоничных натур, умеющих понимать и принимать окружающих, а также ценящих стабильность');
    ''');

    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456821','Букет невесты из гипсофилы','Нежный воздушный как облако букет невесты из белой гипсофилы. Подойдет к любому образу невесты, будь то строгий костюм, лаконичное платье в пол, воздушный и легкий крой',3490,'Гипсофила белая - 9, Лента атласная - 1','https://content2.flowwow-images.com/data/flowers/1000x1000/41/1690544970_69918441.jpg','550e8400-e29b-41d4-a716-446655440005','6a1c2f20-4e02-4d8f-b7c8-123456789001','Гипсофила означает новую жизнь, начало чего-то, рождение. Белые цветки говорят об искренности, невинности, верности и чистоте');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456822','Облако нежной гипсофилы','Облако нежности. Букет из воздушных гипсофил создаст атмосферу легкости и романтики',3650,'Гипсофила - 9, Дизайнерская упаковка - 2','https://content2.flowwow-images.com/data/flowers/1000x1000/39/1736772161_33241439.jpg','550e8400-e29b-41d4-a716-446655440005','6a1c2f20-4e02-4d8f-b7c8-123456789002','Гипсофила может символизировать начало новой жизни, чистоту помыслов, искренность, святость и духовность. Также этому цветку приписывается значение упорного труда, связанное с тем, что ему приходится преодолевать плотный слой почвы, чтобы вырваться наружу и расцвести');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456823','Нежно-розовый букет-гигант из гипсофилы','Воздушный и такой нежный букет из воздушной нежно-розовой гипсофилы в дизайнерской упаковке с атласной лентой',4700,'Гипсофила - 11, Дизайнерская упаковка - 1, Лента атласная - 1','https://flawery.ru/image/thumb_610/products/134180/1130421_0.jpg','550e8400-e29b-41d4-a716-446655440005','6a1c2f20-4e02-4d8f-b7c8-123456789003','Гипсофила может символизировать начало новой жизни, чистоту помыслов, искренность, святость и духовность. Также этому цветку приписывается значение упорного труда, связанное с тем, что ему приходится преодолевать плотный слой почвы, чтобы вырваться наружу и расцвести');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456824','Композиция из белоснежной гипсофилы с хлопком','Белоснежная композиция с хлопком подойдёт для любого повода и впишется в любой интерьер. Гипсофила очень стойкий цветок, но и после высыхания она не потеряет форму и будет продолжать радовать получателя как сухоцвет',2450,'Гипсофила - 7, Хлопок бутон - 1, Коробка - 1, Лента атласная - 1','https://flawery.ru/image/thumb_610/products/150806/1173999_0.jpg','550e8400-e29b-41d4-a716-446655440005','6a1c2f20-4e02-4d8f-b7c8-123456789004','Гипсофила может символизировать начало новой жизни, чистоту помыслов, искренность, святость и духовность. Также этому цветку приписывается значение упорного труда, связанное с тем, что ему приходится преодолевать плотный слой почвы, чтобы вырваться наружу и расцвести');
    ''');
    await db.execute('''
     INSERT INTO `Flower` (`id`,`name`,`description`,`cost`,`composition`,`image`,`category_id`,`selection_id`,`legend`) VALUES ('c1a1b2c3-d4e5-6789-abcd-ef0123456825','Воздушное сердце гипсофилы','Воздушное сердце из пышной гипсофилы в шляпной коробке с атласной лентой. Цветы собраны на флористической губке оазис, требуют умеренного полива каждые 2 дня',3900,'Гипсофила - 7, Лента атласная - 2, Оазис - 2, Шляпная коробка - 1','https://flawery.ru/image/thumb_610/products/134180/1210210_0.jpg','550e8400-e29b-41d4-a716-446655440005','6a1c2f20-4e02-4d8f-b7c8-123456789005','Гипсофила может символизировать начало новой жизни, чистоту помыслов, искренность, святость и духовность. Также этому цветку приписывается значение упорного труда, связанное с тем, что ему приходится преодолевать плотный слой почвы, чтобы вырваться наружу и расцвести');
    ''');
  }

  // Добавление подборки
  Future<void> insertSelection(Selection selection) async {
    final db = await database;
    await db.insert(
      'Selection',
      selection.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Изменение параметра icon подборки
  Future<void> updateSelectionIcon(String id, String newIcon) async {
    final db = await database;

    await db.update(
      'Selection',
      {'icon': newIcon},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Добавление категории
  Future<void> insertCategory(Category category) async {
    final db = await database;
    await db.insert(
      'Category',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Добавление букета
  Future<void> insertFlower(Flower flower) async {
    final db = await database;
    await db.insert(
      'Flower',
      flower.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Изменение параметра image у букета
  Future<void> updateFlowerImage(String id, String newImage) async {
    final db = await database;

    await db.update(
      'Flower',
      {'image': newImage},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Добавление букета в корзину
  Future<void> insertCart(Cart cart) async {
    final db = await database;
    await db.insert(
      'Cart',
      cart.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Вывод списка цветов по категории
  Future<List<Flower>> getFlowersByCategory(String categoryId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Flower',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );

    return List.generate(maps.length, (i) {
      return Flower(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        cost: maps[i]['cost'],
        composition: maps[i]['composition'],
        legend: maps[i]['legend'],
        image: maps[i]['image'],
        categoryId: maps[i]['category_id'],
        selectionId: maps[i]['selection_id'],
      );
    });
  }

  // Вывод списка цветов по подборке
  Future<List<Flower>> getFlowersBySelection(String selectionId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Flower',
      where: 'selection_id = ?',
      whereArgs: [selectionId],
    );

    return List.generate(maps.length, (i) {
      return Flower(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        cost: maps[i]['cost'],
        composition: maps[i]['composition'],
        legend: maps[i]['legend'],
        image: maps[i]['image'],
        categoryId: maps[i]['category_id'],
        selectionId: maps[i]['selection_id'],
      );
    });
  }

  // Удалить аккаунт
  Future<void> deleteUser(String userId) async {
    final db = await database;
    await db.delete('User', where: 'id = ?', whereArgs: [userId]);
  }

  // Удалить букет по ID
  Future<void> deleteFlower(String flowerId) async {
    final db = await database;
    await db.delete('Flower', where: 'id = ?', whereArgs: [flowerId]);
  }

  // Изменить аккаунт (например, обновить имя и профиль)
  Future<void> updateUser(String userId, String name, String profileImg) async {
    final db = await database;
    await db.update(
      'User',
      {'name': name, 'profile_img': profileImg},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // Добавить аккаунт
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'User',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Сохранение ID авторизованного пользователя
  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', userId);
  }

  // Получение ID авторизованного пользователя
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<User> getUserById(String? userId) async {
    final db = await database;
    final List<Map<String, dynamic>> userData = await db.query(
      'User',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (userData.isNotEmpty) {
      return User.fromMap(userData.first);
    } else {
      throw Exception("User not found");
    }
  }

  // Удаление ID при выходе из аккаунта
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }

  // Добавить аккаунт
  Future<void> allUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('User');

    for (var map in maps) {
      print(map);
    }
  }

  // Вход в аккаунт (по email и password)
  Future<User?> login(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'User',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Вывод списка понравившихся цветов
  Future<List<Flower>> getFavorites(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'Favorites',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    List<Flower> favoriteFlowers = [];
    for (var map in maps) {
      final flower = await getFlowerById(map['flower_id']);
      favoriteFlowers.add(flower);
    }

    return favoriteFlowers;
  }

  // Добавление букета в понравившееся
  Future<void> insertFavorites(Favorites favorites) async {
    final db = await database;
    await db.insert(
      'Favorites',
      favorites.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavorite(String userId, String flowerId) async {
    final db = await database;
    await db.delete(
      'Favorites',
      where: 'user_id = ? AND flower_id = ?',
      whereArgs: [userId, flowerId],
    );
  }

  Future<List<Cart>> getCartItems(String userId) async {
    final db = await database;

    final List<Map<String, dynamic>> cartData = await db.query(
      'Cart',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    List<Cart> cartItems = [];

    for (var cartItem in cartData) {
      String flowerId = cartItem['flower_id'];
      // print(cartItem);

      // Получаем данные о цветке из таблицы Flower
      final List<Map<String, dynamic>> flowerData = await db.query(
        'Flower',
        where: 'id = ?',
        whereArgs: [flowerId],
      );

      if (flowerData.isNotEmpty) {
        // Создаем объект Cart с учетом информации о цветке и количестве
        final cart = Cart(
          user_id: cartItem['user_id'],
          flower_id: cartItem['flower_id'],
          quantity: cartItem['quantity'],
        );

        cartItems.add(cart);
      }
    }

    return cartItems;
  }

  // Добавление товара в корзину (увеличивает количество, если товар уже есть)
  Future<void> insertOrUpdateCart(Cart cart) async {
    final db = await database;

    final existingCartItem = await db.query(
      'Cart',
      where: 'user_id = ? AND flower_id = ?',
      whereArgs: [cart.user_id, cart.flower_id],
    );

    if (existingCartItem.isNotEmpty) {
      // int currentQuantity = existingCartItem.first['quantity'] as int;
      await db.update(
        'Cart',
        {'quantity': cart.quantity + 1},
        where: 'user_id = ? AND flower_id = ?',
        whereArgs: [cart.user_id, cart.flower_id],
      );
    } else {
      await db.insert(
        'Cart',
        cart.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Удаление товара из корзины
  Future<void> removeFromCart(String userId, String flowerId) async {
    final db = await database;
    await db.delete(
      'Cart',
      where: 'user_id = ? AND flower_id = ?',
      whereArgs: [userId, flowerId],
    );
  }

  // Уменьшение количества товара в корзине (если 1 — удаляем)
  Future<void> decreaseCartQuantity(String userId, String flowerId) async {
    final db = await database;
    final existingCartItem = await db.query(
      'Cart',
      where: 'user_id = ? AND flower_id = ?',
      whereArgs: [userId, flowerId],
    );

    if (existingCartItem.isNotEmpty) {
      int currentQuantity = existingCartItem.first['quantity'] as int;
      if (currentQuantity > 1) {
        await db.update(
          'Cart',
          {'quantity': currentQuantity - 1},
          where: 'user_id = ? AND flower_id = ?',
          whereArgs: [userId, flowerId],
        );
      } else {
        await removeFromCart(userId, flowerId);
      }
    }
  }

  // Получение всех подборок
  Future<List<Selection>> getAllSelections() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Selection');

    return List.generate(maps.length, (i) {
      return Selection(
        id: maps[i]['id'],
        name: maps[i]['name'],
        icon: maps[i]['icon'],
      );
    });
  }

  // Получение всех категорий
  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Category');

    return List.generate(maps.length, (i) {
      return Category(id: maps[i]['id'], name: maps[i]['name']);
    });
  }

  // Получение букета по ID
  Future<Flower> getFlowerById(String flowerId) async {
    final db = await database;
    final List<Map<String, dynamic>> flowerData = await db.query(
      'Flower',
      where: 'id = ?',
      whereArgs: [flowerId],
    );

    if (flowerData.isNotEmpty) {
      return Flower.fromMap(flowerData.first);
    } else {
      throw Exception("Flower not found");
    }
  }

  // Получение списка всех букетов
  Future<List<Flower>> getAllFlowers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Flower');

    // for (var map in maps) {
    //   print(map);
    // }

    return List.generate(maps.length, (i) {
      return Flower(
        id: maps[i]['id'] ?? '',
        name: maps[i]['name'] ?? '',
        cost: maps[i]['cost'] ?? '0',
        image: maps[i]['image'] ?? '',
        description: maps[i]['description'] ?? '',
        composition: maps[i]['composition'] ?? '',
        legend: maps[i]['legend'] ?? '',
        categoryId: maps[i]['categoryId'] ?? '',
        selectionId: maps[i]['selectionId'] ?? '',
      );
    });
  }
}
