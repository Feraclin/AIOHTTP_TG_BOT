--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4 (Ubuntu 14.4-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.4

-- Started on 2022-09-20 06:56:01

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

--
-- TOC entry 3391 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 211 (class 1259 OID 80316)
-- Name: admins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE public.admins OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 80315)
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admins_id_seq OWNER TO postgres;

--
-- TOC entry 3392 (class 0 OID 0)
-- Dependencies: 210
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- TOC entry 209 (class 1259 OID 80310)
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 80345)
-- Name: game_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.game_session (
    id integer NOT NULL,
    chat_id bigint NOT NULL,
    capitan_id bigint,
    status character varying(32),
    start_date timestamp without time zone NOT NULL,
    bot_point integer,
    team_point integer
);


ALTER TABLE public.game_session OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 80344)
-- Name: game_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.game_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.game_session_id_seq OWNER TO postgres;

--
-- TOC entry 3393 (class 0 OID 0)
-- Dependencies: 216
-- Name: game_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.game_session_id_seq OWNED BY public.game_session.id;


--
-- TOC entry 219 (class 1259 OID 80357)
-- Name: game_session_question; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.game_session_question (
    id integer NOT NULL,
    question_id integer NOT NULL,
    game_session_id integer NOT NULL,
    status character varying(32),
    player_answer character varying(32),
    respondent bigint
);


ALTER TABLE public.game_session_question OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 80356)
-- Name: game_session_question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.game_session_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.game_session_question_id_seq OWNER TO postgres;

--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 218
-- Name: game_session_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.game_session_question_id_seq OWNED BY public.game_session_question.id;


--
-- TOC entry 213 (class 1259 OID 80327)
-- Name: question_cgk; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question_cgk (
    id integer NOT NULL,
    title text NOT NULL,
    answer character varying(32)[] NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.question_cgk OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 80326)
-- Name: question_cgk_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_cgk_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_cgk_id_seq OWNER TO postgres;

--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 212
-- Name: question_cgk_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_cgk_id_seq OWNED BY public.question_cgk.id;


--
-- TOC entry 221 (class 1259 OID 80379)
-- Name: team_models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_models (
    id integer NOT NULL,
    session_id integer NOT NULL,
    user_id bigint NOT NULL
);


ALTER TABLE public.team_models OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 80378)
-- Name: team_models_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.team_models_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.team_models_id_seq OWNER TO postgres;

--
-- TOC entry 3396 (class 0 OID 0)
-- Dependencies: 220
-- Name: team_models_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.team_models_id_seq OWNED BY public.team_models.id;


--
-- TOC entry 215 (class 1259 OID 80338)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    nick character varying(32) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 80337)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3397 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3204 (class 2604 OID 80319)
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- TOC entry 3207 (class 2604 OID 80348)
-- Name: game_session id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_session ALTER COLUMN id SET DEFAULT nextval('public.game_session_id_seq'::regclass);


--
-- TOC entry 3208 (class 2604 OID 80360)
-- Name: game_session_question id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_session_question ALTER COLUMN id SET DEFAULT nextval('public.game_session_question_id_seq'::regclass);


--
-- TOC entry 3205 (class 2604 OID 80330)
-- Name: question_cgk id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_cgk ALTER COLUMN id SET DEFAULT nextval('public.question_cgk_id_seq'::regclass);


--
-- TOC entry 3209 (class 2604 OID 80382)
-- Name: team_models id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_models ALTER COLUMN id SET DEFAULT nextval('public.team_models_id_seq'::regclass);


--
-- TOC entry 3206 (class 2604 OID 80341)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3375 (class 0 OID 80316)
-- Dependencies: 211
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admins (id, email, password) FROM stdin;
1	admin@admin.com	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
\.


--
-- TOC entry 3373 (class 0 OID 80310)
-- Dependencies: 209
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
6944838fe25d
\.


--
-- TOC entry 3381 (class 0 OID 80345)
-- Dependencies: 217
-- Data for Name: game_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.game_session (id, chat_id, capitan_id, status, start_date, bot_point, team_point) FROM stdin;
\.


--
-- TOC entry 3383 (class 0 OID 80357)
-- Dependencies: 219
-- Data for Name: game_session_question; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.game_session_question (id, question_id, game_session_id, status, player_answer, respondent) FROM stdin;
\.


--
-- TOC entry 3377 (class 0 OID 80327)
-- Dependencies: 213
-- Data for Name: question_cgk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.question_cgk (id, title, answer, description) FROM stdin;
1	Книги Ильи Масо́дова относятся к жанру хо́ррор, однако содержат в себе и сексуальные сцены. По одной из версий, псевдоним «Масодов» образован от тех же корней, что и более известное слово. Напишите это слово.	{садомазохизм,садомазо}	Речь о корнях «сад» и «мазох». Книги Масодова действительно наполнены болью с сексуальным подтекстом, но чаще всего всё заканчивается плохо и не к взаимному удовольствию участников.
2	Исследователь отмечает, что в современных интерпретациях ОН часто завидует братьям, хотя на самом деле ЕМУ достался лучший вариант, ведь число ЕГО подданных постоянно растёт. Назовите ЕГО.	{аид,гадес,плутон}	Bо многих произведениях Аида изображают завистником Зевса, желающим отобрать у него власть над миром земным. На деле же Аид был доволен доставшемуся ему по жребию царством мёртвых. 
3	Почему предприниматели боятся сломанной скамьи?	{банкротство,банкрот}	banca rotta (итал.) — сломанная скамья; отсюда банкротство
4	Назовите, пожалуйста, национальность самой известной из ныне существующих пастушек облаков	{француженка,француз,французское}	Пастушкой облаков французы (и не только они) называют Эйфелеву башню в Париже
5	Древняя африканская монархия шиллуков отличалась крепкими традициями и своеобразными обычаями. А кем, как вы думаете, мог быть шиллук, чтобы его могли убить только из-за того, что он чихнул?	{король,вождь,правитель}	Т.к. проявил слабость, что непростительно для такой особы
6	Лев, коза, дракон. Назовите четвертое слово, которое бы их объединяло.	{химера}	Т.к. объединяет эти три существа в одно
7	В гербе какой страны их три, хотя счастливыми считаются четыре?	{ирландия}	Лепестки клевера
8	Назовите точное количество слов, которое должно находиться в активной лексике молодой особы женского пола, чтобы, по мнению классиков советской литературы, ее можно было отнести к культурным людям?	{"180 слов",180}	Именно столько слов было в языке у подруги Эллочки Щукиной Фимы Собак. Кроме того, она знала необыкновенно богатое слово "гомосексуализм"
9	В дореволюционной России самой популярной тарой для спиртных напитков была т.н. "четверть". А четверть чего?	{ведра,ведро}	В дореволюционной России это была бутыль в 3 литра.
10	Как известно, Цезарь был не только великим императором, но и выдающимся полководцем, а римские полководцы после победоносной войны праздновали триумф. Цезарь за свою жизнь был триумфатором 4 раза. Что помешало ему отпраздновать 5-ю победу — над мятежным Помпеем?	{гуманность,гуманизм}	Римляне считали недопустимым праздновать победу в гражданской войне, т. е. над своими же соотечественниками.
11	Гладиаторскими боями славится не только Древний Рим (вспомните хотя бы современную испанскую корриду). Так, на Гавайских островах в Тихом океане местные жители наслаждались еще несколько веков назад необычными гладиаторскими боями. Один из цирков находился на том месте, где позже была построена американская военно-морская база, разгромленная японцами в 1943г. С кем сражались гладиаторы?	{акулы}	"Тени в море"
12	"Первая цитата: ""... получив известие о столь дерзком намерении, бросил все свои... дела и с невероятной быстротой устремился против... царя"".\r\n    Вторая: ""... встретился с его войсками у реки Зелы..."".\r\n    Третья: ""... некоторое время его теснила конница вместе с секироносцами, а затем он одержал верх с помощью тяжеловооруженной пехоты"".\r\n    Назовите человека, о котором идет речь в этих цитатах. "	{цезарь,кесарь}	Первая цитата — "пришел", вторая цитата — "увидел", третья цитата — "победил". Цитаты из Диона Кассия, 42, 47-48.
13	Обычно ОНА появляется благодаря пылинке. ОНА дала название фабрике Вологодских кружев. Догадайтесь и ответьте, какая заглавная героиня иностранного произведения XIX века умела превращаться в НЕЕ.	{"снежная королева"}	Она — снежинка. Снежинки обычно начинают расти вокруг пылинки.
14	На одном острове есть более двухсот географических объектов, названия которых начинаются с одних и тех же трех слогов. Третий слог "ми" означает "смотри". Воспроизведите русскими буквами два первых слога.	{фудзи,фудзияма}	Из этих мест Хонсю открывается виды на Фудзияму. Японцы известны страстью любоваться Фудзи с различных ракурсов.
15	В русском флоте наиболее популярными были три имени почтовых кораблей. Два из них — "Курьер" и "Почтальон". Третье имя также носил боевой корабль под командованием Казарского. Напишите это имя.	{меркурий}	Меркурий — вестник богов. "Меркурий" — бриг, прославившийся в Русско-турецкой войне 1828-29 гг.
16	"10 ноября 675 года, около часа первого факела, в таверне Венеры Либитины было особенно много народу". Это цитата из начала произведения, действие которого заканчивается примерно семью годами позже. Назовите это произведение.	{спартак}	Комментарий: 675 по римскому календарю (от основания Рима в 753 году до н.э.) соответствует 78 году до н.э. — году, в котором произошло восстание Спартака.
17	Недавно был ограблен ювелирный магазин в центре французского города Мец. Во время ограбления преступники воспользовались молотком и еще неким устройством. Назовите того, кто использовал это же устройство в аналогичных целях, но по отношению к мучным изделиям.	{Карлсон}	Устройство — пылесос
18	Бывший министр финансов Александр Лифшиц рассказывал, что проекты указов прежде, чем попасть на подпись к Ельцину, обрастали мнениями, отзывами и заключениями разных сановников. Так, проект указа о приснопамятном дефолте, по мнению Лифшица, "прошел не через тех мухтаров". Какое слово мы заменили словом "мухтаров"?	{визирей,визирь}	Так он назвал тех, кто ставил визы.
19	Персонаж Джека Лондона, поясняя значение слова "паттеран", рассказывает, что это путеводный знак на дороге в виде двух перекрещенных прутиков растений разных видов. В произведении нобелевского лауреата несколько раз встречаются слова "романи паттеран". Русский перевод этого произведения широко известен в сокращенном варианте. Назовите первые два слова этого перевода.	{"мохнатый шмель"}	Паттеран в переводе Г.Кружкова назван цыганской звездой.
21	Если верить герою Хайнлайна, ОНА вызывает зависимость куда худшую, чем курение марихуаны, но более дешевую, чем употребление героина. К тому же заснуть без НЕЕ трудно. А когда профессор Московского университета Мерзляков спросил у Жуковского, чего можно ожидать от вступившего на престол Николая I, поэт ответил, что судить о том можно хотя бы по тому, что он ни разу не видел императора с НЕЙ. Назовите ЕЕ.	{книга,книги,книг}	Жуковский отвечал: "Суди сам — я никогда не видел книги в руках [Николая]; единственное занятие — фрунт и солдаты". Хайнлайн так писал о привычке к чтению книг.
22	Компания "Memorex" выпустила клавиатуру, имеющую необычную особенность. На одной из функциональных кнопок вместо привычного числа находится другое, чуть меньшее. Нажатие на эту кнопку отправляет пользователя на сайт, посвященный... Кому?	{"гарри поттеру",поттеру,поттер}	Клавиатура имеет кнопку F9 3/4. Так же называется железнодорожная платформа в книге о Гарри Поттере
23	Один китайский путешественник в конце 18 века побывал в Европе и написал путевые заметки о странах, которые он объездил. В своих заметках он упомянул и о стране Мье Ли Кан, в которой он не был. По его описанию, это "маленький изолированный остров в середине океана. Его можно достичь морем из Англии примерно за десять дней... Теперь это независимая страна, но ее обычаи до сих пор во многом схожи с бывшей метрополией". Конец цитаты. Так что же это за страна такая — Мье Ли Кан?	{америка,сша}	Обратите внимание на созвучность
24	В 2015 году один поэт написал сообщение в Твиттере: "Небо плачет — ...". Закончите сообщение двумя словами.	{"умер пратчетт"}	12 марта 2015 года скончался знаменитый писатель
25	Герой рассказа Редьярда Киплинга по имени ОртЕрис и его два друга смело вступили в сражение с врагами. Впрочем, позже говорили, что им помогал еще один человек. Как называется этот рассказ?	{"три мушкетера"}	Четвертый "герой" схватки у Киплинга вернулся уже после того, как битва закончилась, но он доказывал, что тоже участвовал в сражении. В вопросе есть намек на цитату из фильма "Д_Артаньян и три мушкетера": "Нас будет трое, <...> а скажут, что нас было четверо". Упомянутое имя ОртЕрис созвучно с именем французского мушкетера
26	В одном романе новобрачные попросили священника чуть изменить текст речи во время свадебной церемонии. Они решили, что слова "отныне и навеки" будут звучать более уместно, чем другие, более привычные слова. А в каком другом романе эта молодая пара познакомилась?	{сумерки,"солнце полуночи"}	Вампиры хотят жить вечно
27	Прежде чем согласиться на очередную роль, пожилой Луи де Фюнес убедился, что его АЛЬФА еще не совсем, так сказать, "беззубая". Какое слово мы заменили АЛЬФОЙ?	{кардиограмма,электрокардиограмма,экг}	Луи де Фюнес советовался с кардиологом. Если на кардиограмме были хоть какие-то зубцы, актер соглашался играть, т.е. фактически соглашался всегда, пока был жив
20	У Гюнтера Грасса в "Собачьих годах" есть следующий эпизод: "Но прежде чем ИКСЫ и ИГРЕКИ, сперва ручейком, потом мощным потоком повлекут его и нас по течению дискуссии, давайте помолимся... О Ты, великий творец динамической и нескончаемо длящейся дискуссии, Ты, кто создал ИКС и ИГРЕК, Ты, который даешь слово и лишаешь слова, да пребудет с нами Твоя поддержка и опора..." Внимание, вопрос! Не будем спрашивать вас, что такое ИКС, лучше правильно напишите ИГРЕК.	{ответ}	Надеюсь, ни у кого не возникло вопроса, что такое ИКС?
\.


--
-- TOC entry 3385 (class 0 OID 80379)
-- Dependencies: 221
-- Data for Name: team_models; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team_models (id, session_id, user_id) FROM stdin;
\.


--
-- TOC entry 3379 (class 0 OID 80338)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, nick) FROM stdin;
\.


--
-- TOC entry 3398 (class 0 OID 0)
-- Dependencies: 210
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admins_id_seq', 21, true);


--
-- TOC entry 3399 (class 0 OID 0)
-- Dependencies: 216
-- Name: game_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.game_session_id_seq', 24, true);


--
-- TOC entry 3400 (class 0 OID 0)
-- Dependencies: 218
-- Name: game_session_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.game_session_question_id_seq', 72, true);


--
-- TOC entry 3401 (class 0 OID 0)
-- Dependencies: 212
-- Name: question_cgk_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.question_cgk_id_seq', 1, false);


--
-- TOC entry 3402 (class 0 OID 0)
-- Dependencies: 220
-- Name: team_models_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.team_models_id_seq', 48, true);


--
-- TOC entry 3403 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 3213 (class 2606 OID 80325)
-- Name: admins admins_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_email_key UNIQUE (email);


--
-- TOC entry 3215 (class 2606 OID 80323)
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- TOC entry 3211 (class 2606 OID 80314)
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- TOC entry 3223 (class 2606 OID 80350)
-- Name: game_session game_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_session
    ADD CONSTRAINT game_session_pkey PRIMARY KEY (id);


--
-- TOC entry 3225 (class 2606 OID 80362)
-- Name: game_session_question game_session_question_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_session_question
    ADD CONSTRAINT game_session_question_pkey PRIMARY KEY (id);


--
-- TOC entry 3217 (class 2606 OID 80334)
-- Name: question_cgk question_cgk_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_cgk
    ADD CONSTRAINT question_cgk_pkey PRIMARY KEY (id);


--
-- TOC entry 3219 (class 2606 OID 80504)
-- Name: question_cgk question_cgk_title_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question_cgk
    ADD CONSTRAINT question_cgk_title_key UNIQUE (title);


--
-- TOC entry 3227 (class 2606 OID 80384)
-- Name: team_models team_models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_models
    ADD CONSTRAINT team_models_pkey PRIMARY KEY (id);


--
-- TOC entry 3221 (class 2606 OID 80343)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3228 (class 2606 OID 80351)
-- Name: game_session game_session_capitan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_session
    ADD CONSTRAINT game_session_capitan_id_fkey FOREIGN KEY (capitan_id) REFERENCES public.users(id);


--
-- TOC entry 3229 (class 2606 OID 80363)
-- Name: game_session_question game_session_question_game_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_session_question
    ADD CONSTRAINT game_session_question_game_session_id_fkey FOREIGN KEY (game_session_id) REFERENCES public.game_session(id) ON DELETE CASCADE;


--
-- TOC entry 3230 (class 2606 OID 80368)
-- Name: game_session_question game_session_question_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_session_question
    ADD CONSTRAINT game_session_question_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.question_cgk(id) ON DELETE CASCADE;


--
-- TOC entry 3231 (class 2606 OID 80373)
-- Name: game_session_question game_session_question_respondent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.game_session_question
    ADD CONSTRAINT game_session_question_respondent_fkey FOREIGN KEY (respondent) REFERENCES public.users(id);


--
-- TOC entry 3232 (class 2606 OID 80385)
-- Name: team_models team_models_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_models
    ADD CONSTRAINT team_models_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.game_session(id) ON DELETE CASCADE;


--
-- TOC entry 3233 (class 2606 OID 80390)
-- Name: team_models team_models_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_models
    ADD CONSTRAINT team_models_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


-- Completed on 2022-09-20 06:56:01

--
-- PostgreSQL database dump complete
--

