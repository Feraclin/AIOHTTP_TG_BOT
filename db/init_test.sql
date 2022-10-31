--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4 (Ubuntu 14.4-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.4

-- Started on 2022-09-17 23:04:22

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


ALTER SCHEMA public OWNER TO postgres;

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
11	109470065	109470065	complete	2022-09-13 20:40:48.336609	0	0
1	109470065	109470065	complete	2022-09-13 18:58:12.247856	0	1
4	-1001567033839	109470065	complete	2022-09-13 19:42:26.659805	0	1
8	109470065	109470065	complete	2022-09-13 20:15:37.20947	1	0
23	-1001567033839	109470065	complete	2022-09-15 07:36:56.119646	1	0
24	109470065	109470065	complete	2022-09-15 07:36:57.768639	1	0
16	-1001567033839	109470065	complete	2022-09-13 23:00:26.015544	0	1
20	109470065	109470065	complete	2022-09-15 07:16:04.867827	0	1
2	109470065	109470065	complete	2022-09-13 19:06:38.960056	0	1
5	-1001567033839	109470065	complete	2022-09-13 19:55:03.660114	0	1
12	109470065	109470065	complete	2022-09-13 20:47:04.391259	0	1
9	109470065	109470065	complete	2022-09-13 20:29:36.82453	1	0
13	109470065	109470065	complete	2022-09-13 20:48:10.792617	0	0
3	-1001567033839	109470065	complete	2022-09-13 19:07:47.886832	0	1
17	-1001567033839	109470065	complete	2022-09-14 12:04:23.303718	0	1
6	109470065	109470065	complete	2022-09-13 20:13:04.238056	1	0
10	109470065	109470065	complete	2022-09-13 20:33:33.247421	0	1
7	109470065	109470065	complete	2022-09-13 20:14:40.690283	1	0
21	109470065	109470065	complete	2022-09-15 07:17:12.243099	0	1
14	142681483	142681483	complete	2022-09-13 22:58:46.550969	1	0
22	-1001567033839	109470065	complete	2022-09-15 07:17:15.100008	0	1
15	109470065	109470065	complete	2022-09-13 22:58:48.180644	1	0
18	-1001567033839	109470065	complete	2022-09-14 12:29:46.242998	1	0
19	109470065	109470065	complete	2022-09-14 12:29:50.161005	1	0
\.


--
-- TOC entry 3383 (class 0 OID 80357)
-- Dependencies: 219
-- Data for Name: game_session_question; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.game_session_question (id, question_id, game_session_id, status, player_answer, respondent) FROM stdin;
2	16	1	\N	\N	\N
3	17	1	\N	\N	\N
50	82	17	\N	\N	\N
51	56	17	\N	\N	\N
1	31	1	complete	answer31-1	109470065
5	95	2	\N	\N	\N
6	49	2	\N	\N	\N
4	15	2	complete	answer15-1	109470065
8	10	3	\N	\N	\N
9	29	3	\N	\N	\N
49	32	17	complete	answer32-1	142681483
7	89	3	complete	answer89-1	109470065
11	13	4	\N	\N	\N
12	68	4	\N	\N	\N
53	29	18	\N	\N	\N
54	64	18	\N	\N	\N
10	62	4	complete	answer62-1	109470065
14	7	5	\N	\N	\N
15	19	5	\N	\N	\N
56	58	19	\N	\N	\N
57	80	19	\N	\N	\N
13	78	5	complete	answer78-1	109470065
18	28	6	\N	\N	\N
52	90	18	complete	\N	142681483
55	52	19	complete	\N	109470065
17	51	6	asked	answer51-2	109470065
16	25	6	complete	answer51-2	109470065
20	12	7	\N	\N	\N
21	40	7	\N	\N	\N
59	93	20	\N	\N	\N
19	73	7	complete	\N	109470065
23	23	8	\N	\N	\N
24	2	8	\N	\N	\N
60	71	20	\N	\N	\N
22	73	8	complete	\N	\N
26	69	9	\N	\N	\N
27	17	9	\N	\N	\N
25	21	9	complete	\N	109470065
29	96	10	\N	\N	\N
30	72	10	\N	\N	\N
58	25	20	complete	answer25-1	109470065
28	55	10	complete	answer55-2	109470065
32	31	11	\N	\N	\N
33	29	11	\N	\N	\N
31	43	11	asked	\N	\N
35	29	12	\N	\N	\N
36	21	12	\N	\N	\N
62	25	21	\N	\N	\N
63	38	21	\N	\N	\N
34	71	12	complete	answer71-1	109470065
37	99	13	\N	\N	\N
38	29	13	\N	\N	\N
39	83	13	\N	\N	\N
41	24	14	\N	\N	\N
42	3	14	\N	\N	\N
44	47	15	\N	\N	\N
45	72	15	\N	\N	\N
65	3	22	\N	\N	\N
66	95	22	\N	\N	\N
40	50	14	complete	жджжд	142681483
43	63	15	complete	нгнгнг	109470065
47	54	16	\N	\N	\N
48	87	16	\N	\N	\N
61	74	21	complete	answer74-1	109470065
46	93	16	complete	answer93-1	142681483
64	4	22	complete	answer4-2	109470065
68	51	23	\N	\N	\N
69	97	23	\N	\N	\N
71	76	24	\N	\N	\N
72	21	24	\N	\N	\N
67	83	23	complete	парпр	142681483
70	82	24	complete	куку	109470065
\.


--
-- TOC entry 3377 (class 0 OID 80327)
-- Dependencies: 213
-- Data for Name: question_cgk; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.question_cgk (id, title, answer, description) FROM stdin;
1	question1	{answer1-1,answer1-2}	desc1
2	question2	{answer2-1,answer2-2}	desc2
3	question3	{answer3-1,answer3-2}	desc3
4	question4	{answer4-1,answer4-2}	desc4
5	question5	{answer5-1,answer5-2}	desc5
6	question6	{answer6-1,answer6-2}	desc6
7	question7	{answer7-1,answer7-2}	desc7
8	question8	{answer8-1,answer8-2}	desc8
9	question9	{answer9-1,answer9-2}	desc9
10	question10	{answer10-1,answer10-2}	desc10
11	question11	{answer11-1,answer11-2}	desc11
12	question12	{answer12-1,answer12-2}	desc12
13	question13	{answer13-1,answer13-2}	desc13
14	question14	{answer14-1,answer14-2}	desc14
15	question15	{answer15-1,answer15-2}	desc15
16	question16	{answer16-1,answer16-2}	desc16
17	question17	{answer17-1,answer17-2}	desc17
18	question18	{answer18-1,answer18-2}	desc18
19	question19	{answer19-1,answer19-2}	desc19
20	question20	{answer20-1,answer20-2}	desc20
21	question21	{answer21-1,answer21-2}	desc21
22	question22	{answer22-1,answer22-2}	desc22
23	question23	{answer23-1,answer23-2}	desc23
24	question24	{answer24-1,answer24-2}	desc24
25	question25	{answer25-1,answer25-2}	desc25
26	question26	{answer26-1,answer26-2}	desc26
27	question27	{answer27-1,answer27-2}	desc27
28	question28	{answer28-1,answer28-2}	desc28
29	question29	{answer29-1,answer29-2}	desc29
30	question30	{answer30-1,answer30-2}	desc30
31	question31	{answer31-1,answer31-2}	desc31
32	question32	{answer32-1,answer32-2}	desc32
33	question33	{answer33-1,answer33-2}	desc33
34	question34	{answer34-1,answer34-2}	desc34
35	question35	{answer35-1,answer35-2}	desc35
36	question36	{answer36-1,answer36-2}	desc36
37	question37	{answer37-1,answer37-2}	desc37
38	question38	{answer38-1,answer38-2}	desc38
39	question39	{answer39-1,answer39-2}	desc39
40	question40	{answer40-1,answer40-2}	desc40
41	question41	{answer41-1,answer41-2}	desc41
42	question42	{answer42-1,answer42-2}	desc42
43	question43	{answer43-1,answer43-2}	desc43
44	question44	{answer44-1,answer44-2}	desc44
45	question45	{answer45-1,answer45-2}	desc45
46	question46	{answer46-1,answer46-2}	desc46
47	question47	{answer47-1,answer47-2}	desc47
48	question48	{answer48-1,answer48-2}	desc48
49	question49	{answer49-1,answer49-2}	desc49
50	question50	{answer50-1,answer50-2}	desc50
51	question51	{answer51-1,answer51-2}	desc51
52	question52	{answer52-1,answer52-2}	desc52
53	question53	{answer53-1,answer53-2}	desc53
54	question54	{answer54-1,answer54-2}	desc54
55	question55	{answer55-1,answer55-2}	desc55
56	question56	{answer56-1,answer56-2}	desc56
57	question57	{answer57-1,answer57-2}	desc57
58	question58	{answer58-1,answer58-2}	desc58
59	question59	{answer59-1,answer59-2}	desc59
60	question60	{answer60-1,answer60-2}	desc60
61	question61	{answer61-1,answer61-2}	desc61
62	question62	{answer62-1,answer62-2}	desc62
63	question63	{answer63-1,answer63-2}	desc63
64	question64	{answer64-1,answer64-2}	desc64
65	question65	{answer65-1,answer65-2}	desc65
66	question66	{answer66-1,answer66-2}	desc66
67	question67	{answer67-1,answer67-2}	desc67
68	question68	{answer68-1,answer68-2}	desc68
69	question69	{answer69-1,answer69-2}	desc69
70	question70	{answer70-1,answer70-2}	desc70
71	question71	{answer71-1,answer71-2}	desc71
72	question72	{answer72-1,answer72-2}	desc72
73	question73	{answer73-1,answer73-2}	desc73
74	question74	{answer74-1,answer74-2}	desc74
75	question75	{answer75-1,answer75-2}	desc75
76	question76	{answer76-1,answer76-2}	desc76
77	question77	{answer77-1,answer77-2}	desc77
78	question78	{answer78-1,answer78-2}	desc78
79	question79	{answer79-1,answer79-2}	desc79
80	question80	{answer80-1,answer80-2}	desc80
81	question81	{answer81-1,answer81-2}	desc81
82	question82	{answer82-1,answer82-2}	desc82
83	question83	{answer83-1,answer83-2}	desc83
84	question84	{answer84-1,answer84-2}	desc84
85	question85	{answer85-1,answer85-2}	desc85
86	question86	{answer86-1,answer86-2}	desc86
87	question87	{answer87-1,answer87-2}	desc87
88	question88	{answer88-1,answer88-2}	desc88
89	question89	{answer89-1,answer89-2}	desc89
90	question90	{answer90-1,answer90-2}	desc90
91	question91	{answer91-1,answer91-2}	desc91
92	question92	{answer92-1,answer92-2}	desc92
93	question93	{answer93-1,answer93-2}	desc93
94	question94	{answer94-1,answer94-2}	desc94
95	question95	{answer95-1,answer95-2}	desc95
96	question96	{answer96-1,answer96-2}	desc96
97	question97	{answer97-1,answer97-2}	desc97
98	question98	{answer98-1,answer98-2}	desc98
99	question99	{answer99-1,answer99-2}	desc99
\.


--
-- TOC entry 3385 (class 0 OID 80379)
-- Dependencies: 221
-- Data for Name: team_models; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.team_models (id, session_id, user_id) FROM stdin;
1	1	109470065
2	1	109470065
3	2	109470065
4	2	109470065
5	3	109470065
6	3	109470065
7	4	109470065
8	4	109470065
9	5	109470065
10	5	109470065
11	6	109470065
12	6	109470065
13	7	109470065
14	7	109470065
15	8	109470065
16	8	109470065
17	9	109470065
18	9	109470065
19	10	109470065
20	10	109470065
21	11	109470065
22	12	109470065
23	12	109470065
24	13	109470065
25	13	109470065
26	14	142681483
27	15	109470065
28	14	142681483
29	15	109470065
30	16	142681483
31	16	142681483
32	16	109470065
33	17	109470065
34	17	142681483
35	17	109470065
36	18	142681483
37	19	109470065
38	18	109470065
39	20	109470065
40	20	109470065
41	21	109470065
42	22	109470065
43	21	109470065
44	22	109470065
45	23	109470065
46	24	109470065
47	24	109470065
48	23	142681483
\.


--
-- TOC entry 3379 (class 0 OID 80338)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, nick) FROM stdin;
109470065	Feraclin
142681483	Svvalllow
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
-- TOC entry 3219 (class 2606 OID 80336)
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


-- Completed on 2022-09-17 23:04:23

--
-- PostgreSQL database dump complete
--

