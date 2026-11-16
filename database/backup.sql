--
-- PostgreSQL database dump
--

\restrict 4YcNbakcxjwNRDvSfFBVVOz1sJAjMwhhcWASumkCsfMsRdfrhrdjFuvaN8BW9FJ

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

-- Started on 2026-11-16 15:45:02

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 24628)
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    id_cliente integer NOT NULL,
    cedula character varying(15) NOT NULL,
    nombres character varying(60) NOT NULL,
    apellidos character varying(60) NOT NULL,
    telefono character varying(20) NOT NULL,
    correo character varying(120) NOT NULL,
    ciudad character varying(60) NOT NULL
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24627)
-- Name: clientes_id_cliente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_id_cliente_seq OWNER TO postgres;

--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 223
-- Name: clientes_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_id_cliente_seq OWNED BY public.clientes.id_cliente;


--
-- TOC entry 220 (class 1259 OID 24587)
-- Name: motos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.motos (
    id_moto integer NOT NULL,
    modelo character varying(60) NOT NULL,
    tipo character varying(20) NOT NULL,
    cilindraje_cc integer NOT NULL,
    anio_modelo integer NOT NULL,
    precio_lista numeric(12,2) NOT NULL,
    CONSTRAINT motos_anio_modelo_check CHECK (((anio_modelo >= 2015) AND (anio_modelo <= 2030))),
    CONSTRAINT motos_cilindraje_cc_check CHECK ((cilindraje_cc > 0)),
    CONSTRAINT motos_precio_lista_check CHECK ((precio_lista > (0)::numeric)),
    CONSTRAINT motos_tipo_check CHECK (((tipo)::text = ANY ((ARRAY['automatica'::character varying, 'semiautomatica'::character varying, 'sport'::character varying, 'enduro'::character varying, 'cruiser'::character varying, 'aventura'::character varying, 'alto cilindraje'::character varying])::text[])))
);


ALTER TABLE public.motos OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24586)
-- Name: motos_id_moto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.motos_id_moto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.motos_id_moto_seq OWNER TO postgres;

--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 219
-- Name: motos_id_moto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.motos_id_moto_seq OWNED BY public.motos.id_moto;


--
-- TOC entry 222 (class 1259 OID 24606)
-- Name: repuestos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.repuestos (
    id_repuesto integer NOT NULL,
    id_moto integer NOT NULL,
    referencia character varying(30) NOT NULL,
    nombre character varying(80) NOT NULL,
    precio numeric(12,2) NOT NULL,
    stock integer NOT NULL,
    CONSTRAINT repuestos_precio_check CHECK ((precio > (0)::numeric)),
    CONSTRAINT repuestos_stock_check CHECK ((stock >= 0))
);


ALTER TABLE public.repuestos OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24605)
-- Name: repuestos_id_repuesto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.repuestos_id_repuesto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.repuestos_id_repuesto_seq OWNER TO postgres;

--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 221
-- Name: repuestos_id_repuesto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.repuestos_id_repuesto_seq OWNED BY public.repuestos.id_repuesto;


--
-- TOC entry 226 (class 1259 OID 24646)
-- Name: vendedores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vendedores (
    id_vendedor integer NOT NULL,
    cedula character varying(15) NOT NULL,
    nombres character varying(60) NOT NULL,
    apellidos character varying(60) NOT NULL,
    telefono character varying(20) NOT NULL,
    correo character varying(120) NOT NULL,
    fecha_ingreso date NOT NULL,
    comision_pct numeric(5,2) NOT NULL,
    CONSTRAINT vendedores_comision_pct_check CHECK (((comision_pct >= (0)::numeric) AND (comision_pct <= (100)::numeric)))
);


ALTER TABLE public.vendedores OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24645)
-- Name: vendedores_id_vendedor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vendedores_id_vendedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vendedores_id_vendedor_seq OWNER TO postgres;

--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 225
-- Name: vendedores_id_vendedor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vendedores_id_vendedor_seq OWNED BY public.vendedores.id_vendedor;


--
-- TOC entry 228 (class 1259 OID 24666)
-- Name: ventas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ventas (
    id_venta integer NOT NULL,
    id_cliente integer NOT NULL,
    id_vendedor integer NOT NULL,
    id_moto integer NOT NULL,
    fecha_venta date NOT NULL,
    numero_chasis character varying(25) NOT NULL,
    forma_pago character varying(15) NOT NULL,
    precio_final numeric(12,2) NOT NULL,
    CONSTRAINT ventas_forma_pago_check CHECK (((forma_pago)::text = ANY ((ARRAY['contado'::character varying, 'credito'::character varying])::text[]))),
    CONSTRAINT ventas_precio_final_check CHECK ((precio_final > (0)::numeric))
);


ALTER TABLE public.ventas OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24665)
-- Name: ventas_id_venta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ventas_id_venta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ventas_id_venta_seq OWNER TO postgres;

--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 227
-- Name: ventas_id_venta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ventas_id_venta_seq OWNED BY public.ventas.id_venta;


--
-- TOC entry 4777 (class 2604 OID 24631)
-- Name: clientes id_cliente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id_cliente SET DEFAULT nextval('public.clientes_id_cliente_seq'::regclass);


--
-- TOC entry 4775 (class 2604 OID 24590)
-- Name: motos id_moto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motos ALTER COLUMN id_moto SET DEFAULT nextval('public.motos_id_moto_seq'::regclass);


--
-- TOC entry 4776 (class 2604 OID 24609)
-- Name: repuestos id_repuesto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repuestos ALTER COLUMN id_repuesto SET DEFAULT nextval('public.repuestos_id_repuesto_seq'::regclass);


--
-- TOC entry 4778 (class 2604 OID 24649)
-- Name: vendedores id_vendedor; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendedores ALTER COLUMN id_vendedor SET DEFAULT nextval('public.vendedores_id_vendedor_seq'::regclass);


--
-- TOC entry 4779 (class 2604 OID 24669)
-- Name: ventas id_venta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas ALTER COLUMN id_venta SET DEFAULT nextval('public.ventas_id_venta_seq'::regclass);


--
-- TOC entry 4969 (class 0 OID 24628)
-- Dependencies: 224
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes (id_cliente, cedula, nombres, apellidos, telefono, correo, ciudad) FROM stdin;
1	1075263418	Carlos Andrés	Muñoz Rojas	3156284719	carlosmunoz.rojas@gmail.com	Neiva
2	1083904562	Laura Marcela	Perdomo Díaz	3204718536	lauraperdomo.diaz@gmail.com	Pitalito
3	12236587	Jorge Iván	Cuéllar Silva	3112950847	jorgeivan.cuellar@gmail.com	Garzón
4	36182754	Diana Patricia	Vargas Losada	3008462193	dianavargas.losada@gmail.com	La Plata
5	1077865203	Andrés Felipe	Polanía Cortés	3217093648	andrespolania.c@gmail.com	Campoalegre
6	1003816745	María José	Trujillo Charry	3502846170	mariajose.trujillo@gmail.com	Neiva
7	7729845	Luis Eduardo	Ramírez Medina	3134058926	luiseduardo.ramirez@gmail.com	Gigante
8	1081736290	Valentina	Ortiz Quintero	3016593874	valentina.ortizq@gmail.com	Rivera
9	1075321987	Santiago	Calderón Puentes	3183627405	santiagocalderon.p@gmail.com	Neiva
10	55174826	Paola Andrea	Rojas Bermeo	3045719382	paolarojas.bermeo@gmail.com	Aipe
11	1079542318	Juan David	Castro Narváez	3168240957	juandavid.castron@gmail.com	Palermo
12	1006427583	Camila	Sánchez Tovar	3229164038	camilasanchez.tovar@gmail.com	Yaguará
\.


--
-- TOC entry 4965 (class 0 OID 24587)
-- Dependencies: 220
-- Data for Name: motos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.motos (id_moto, modelo, tipo, cilindraje_cc, anio_modelo, precio_lista) FROM stdin;
1	Burgman Street 125	automatica	124	2026	9800000.00
2	Gixxer 150 DI	sport	155	2026	10500000.00
3	Gixxer FI 150	sport	155	2026	11200000.00
4	GSX-R150	sport	147	2026	13900000.00
5	Gixxer 250	sport	249	2026	16500000.00
6	Gixxer 250 FI	sport	249	2026	17900000.00
7	V-Strom 250 SX	aventura	249	2026	22500000.00
8	V-Strom 650 XT	aventura	645	2026	58000000.00
9	GSX-8S	alto cilindraje	776	2026	52000000.00
10	GSX-R1000R	alto cilindraje	999	2025	110000000.00
11	Hayabusa-Gris	alto cilindraje	1340	2026	125000000.00
\.


--
-- TOC entry 4967 (class 0 OID 24606)
-- Dependencies: 222
-- Data for Name: repuestos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.repuestos (id_repuesto, id_moto, referencia, nombre, precio, stock) FROM stdin;
1	1	REP-0001	Pastillas de freno delanteras	85000.00	15
2	2	REP-0002	Filtro de aceite	28000.00	40
3	2	REP-0003	Kit de arrastre (cadena y piñones)	195000.00	8
4	3	REP-0004	Bujía de encendido	22000.00	50
5	5	REP-0005	Filtro de aire	65000.00	12
6	6	REP-0006	Batería 12V	210000.00	4
7	7	REP-0007	Espejo retrovisor derecho	75000.00	6
8	7	REP-0008	Llanta trasera 140/70-17	380000.00	3
9	8	REP-0009	Pastillas de freno traseras	160000.00	10
10	9	REP-0010	Cable de clutch	95000.00	0
11	10	REP-0011	Farola delantera LED	1850000.00	2
12	11	REP-0012	Kit de embrague	1250000.00	1
\.


--
-- TOC entry 4971 (class 0 OID 24646)
-- Dependencies: 226
-- Data for Name: vendedores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vendedores (id_vendedor, cedula, nombres, apellidos, telefono, correo, fecha_ingreso, comision_pct) FROM stdin;
1	1075218364	Andrés	Cuéllar Vargas	3125947361	andres.cuellarv@gmail.com	2019-03-15	2.50
2	1075284937	Natalia	Gómez Perdomo	3013648295	nataliagomez.perdomo@gmail.com	2020-07-01	2.00
3	12195843	Óscar	Medina Salazar	3147285016	oscarmedina.salazar@gmail.com	2021-01-18	2.25
4	1083872145	Juliana	Rivas Andrade	3209536871	julianarivas.andrade@gmail.com	2021-09-06	1.75
5	1080296473	Felipe	Arias Montealegre	3152704689	felipe.ariasm@gmail.com	2022-04-20	2.00
6	36289517	Mónica	Lozano Cabrera	3006174852	monicalozano.cabrera@gmail.com	2022-11-02	3.00
7	1075309825	Daniel	Paredes Molina	3174826390	danielparedes.molina@gmail.com	2023-05-15	1.50
8	1004738216	Sofía	Herrera Bonilla	3507391246	sofiaherrera.bonilla@gmail.com	2024-02-12	2.00
9	1077924581	Cristian	Ospina Guzmán	3118560274	cristianospina.g@gmail.com	2025-06-01	1.50
10	1005862347	Alejandra	Navarro Fierro	3192485637	alejandranavarro.f@gmail.com	2026-08-01	1.50
\.


--
-- TOC entry 4973 (class 0 OID 24666)
-- Dependencies: 228
-- Data for Name: ventas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ventas (id_venta, id_cliente, id_vendedor, id_moto, fecha_venta, numero_chasis, forma_pago, precio_final) FROM stdin;
1	1	1	1	2026-01-15	MSZ-BUR-260001	contado	9600000.00
2	2	2	2	2026-02-03	MSZ-GDI-260002	credito	10500000.00
3	3	1	5	2026-02-20	MSZ-G25-260003	credito	16300000.00
4	4	3	7	2026-03-11	MSZ-VS2-260004	contado	22000000.00
5	5	4	3	2026-04-02	MSZ-GFI-260005	credito	11200000.00
6	6	5	6	2026-05-14	MSZ-GSF-260006	contado	17500000.00
7	1	6	8	2026-06-21	MSZ-VS6-260007	credito	57000000.00
8	7	7	9	2026-07-08	MSZ-S75-260008	contado	51000000.00
9	8	2	10	2026-08-19	MSZ-R1K-260009	credito	108000000.00
10	9	8	11	2026-09-05	MSZ-HAY-260010	contado	123500000.00
11	10	9	1	2026-10-12	MSZ-BUR-260011	credito	9800000.00
12	11	3	2	2026-11-02	MSZ-GDI-260012	contado	10300000.00
\.


--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 223
-- Name: clientes_id_cliente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_id_cliente_seq', 12, true);


--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 219
-- Name: motos_id_moto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.motos_id_moto_seq', 11, true);


--
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 221
-- Name: repuestos_id_repuesto_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.repuestos_id_repuesto_seq', 12, true);


--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 225
-- Name: vendedores_id_vendedor_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vendedores_id_vendedor_seq', 10, true);


--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 227
-- Name: ventas_id_venta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ventas_id_venta_seq', 12, true);


--
-- TOC entry 4798 (class 2606 OID 24642)
-- Name: clientes clientes_cedula_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_cedula_key UNIQUE (cedula);


--
-- TOC entry 4800 (class 2606 OID 24644)
-- Name: clientes clientes_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_correo_key UNIQUE (correo);


--
-- TOC entry 4802 (class 2606 OID 24640)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente);


--
-- TOC entry 4790 (class 2606 OID 24604)
-- Name: motos motos_modelo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motos
    ADD CONSTRAINT motos_modelo_key UNIQUE (modelo);


--
-- TOC entry 4792 (class 2606 OID 24602)
-- Name: motos motos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.motos
    ADD CONSTRAINT motos_pkey PRIMARY KEY (id_moto);


--
-- TOC entry 4794 (class 2606 OID 24619)
-- Name: repuestos repuestos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repuestos
    ADD CONSTRAINT repuestos_pkey PRIMARY KEY (id_repuesto);


--
-- TOC entry 4796 (class 2606 OID 24621)
-- Name: repuestos repuestos_referencia_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repuestos
    ADD CONSTRAINT repuestos_referencia_key UNIQUE (referencia);


--
-- TOC entry 4804 (class 2606 OID 24662)
-- Name: vendedores vendedores_cedula_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendedores
    ADD CONSTRAINT vendedores_cedula_key UNIQUE (cedula);


--
-- TOC entry 4806 (class 2606 OID 24664)
-- Name: vendedores vendedores_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendedores
    ADD CONSTRAINT vendedores_correo_key UNIQUE (correo);


--
-- TOC entry 4808 (class 2606 OID 24660)
-- Name: vendedores vendedores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vendedores
    ADD CONSTRAINT vendedores_pkey PRIMARY KEY (id_vendedor);


--
-- TOC entry 4810 (class 2606 OID 24683)
-- Name: ventas ventas_numero_chasis_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_numero_chasis_key UNIQUE (numero_chasis);


--
-- TOC entry 4812 (class 2606 OID 24681)
-- Name: ventas ventas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_pkey PRIMARY KEY (id_venta);


--
-- TOC entry 4813 (class 2606 OID 24622)
-- Name: repuestos repuestos_id_moto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.repuestos
    ADD CONSTRAINT repuestos_id_moto_fkey FOREIGN KEY (id_moto) REFERENCES public.motos(id_moto) ON DELETE RESTRICT;


--
-- TOC entry 4814 (class 2606 OID 24684)
-- Name: ventas ventas_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente) ON DELETE RESTRICT;


--
-- TOC entry 4815 (class 2606 OID 24694)
-- Name: ventas ventas_id_moto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_id_moto_fkey FOREIGN KEY (id_moto) REFERENCES public.motos(id_moto) ON DELETE RESTRICT;


--
-- TOC entry 4816 (class 2606 OID 24689)
-- Name: ventas ventas_id_vendedor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ventas
    ADD CONSTRAINT ventas_id_vendedor_fkey FOREIGN KEY (id_vendedor) REFERENCES public.vendedores(id_vendedor) ON DELETE RESTRICT;


-- Completed on 2026-11-16 15:45:03

--
-- PostgreSQL database dump complete
--

\unrestrict 4YcNbakcxjwNRDvSfFBVVOz1sJAjMwhhcWASumkCsfMsRdfrhrdjFuvaN8BW9FJ

