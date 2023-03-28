--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.4

-- Started on 2023-03-25 12:47:07

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
-- TOC entry 236 (class 1255 OID 141106)
-- Name: percent_memory(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.percent_memory(p_value_memory_available character varying, p_value_memory_total character varying) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
declare percent_value float;
begin
if cast (p_value_memory_total as decimal(38,4))<>0 then
select 100-cast(p_value_memory_available as decimal(38,4))*100/cast (p_value_memory_total as decimal(38,4)) into percent_value;
end if;
select 0 into percent_value;
 return percent_value;
end;
$$;


ALTER FUNCTION public.percent_memory(p_value_memory_available character varying, p_value_memory_total character varying) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 141107)
-- Name: percent_size(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.percent_size(p_value_size_free character varying, p_time_size_total character varying) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
declare percent_value float;
begin
if cast (p_time_size_total as decimal(38,4))<>0 then
select 100-cast(p_value_size_free as decimal(38,4))*100/cast (p_time_size_total as decimal(38,4)) into percent_value;
else 
select 0 into percent_value;
end if;
 return percent_value;
end;
$$;


ALTER FUNCTION public.percent_size(p_value_size_free character varying, p_time_size_total character varying) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 141108)
-- Name: work_calculation(double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.work_calculation(p_percent_size double precision, p_percent_memory double precision, p_value_cpu_util_user double precision) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
declare work_calculation varchar(50);
begin
if p_percent_size>=95 or p_percent_memory>=90 or p_value_cpu_util_user>=90
then select 'Частично работоспособен' into work_calculation;
else select 'Работоспособен' into work_calculation;
end if;
return work_calculation;
end;
$$;


ALTER FUNCTION public.work_calculation(p_percent_size double precision, p_percent_memory double precision, p_value_cpu_util_user double precision) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 148754)
-- Name: User; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."User" (
    id_user integer NOT NULL,
    surname character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    patronymic character varying(50),
    login character varying(50) NOT NULL,
    password character varying NOT NULL
);


ALTER TABLE public."User" OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 148752)
-- Name: User_id_user_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."User_id_user_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."User_id_user_seq" OWNER TO postgres;

--
-- TOC entry 3230 (class 0 OID 0)
-- Dependencies: 234
-- Name: User_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."User_id_user_seq" OWNED BY public."User".id_user;


--
-- TOC entry 202 (class 1259 OID 141116)
-- Name: cpu_Iowait; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."cpu_Iowait" (
    "id_cpu_Iowait" integer NOT NULL,
    hostid integer NOT NULL,
    "value_cpu_Iowait" double precision DEFAULT 0.0 NOT NULL,
    "time_value_cpu_Iowait" timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_lowait CHECK ((("value_cpu_Iowait" >= (0)::double precision) AND ("value_cpu_Iowait" <= (100)::double precision)))
);


ALTER TABLE public."cpu_Iowait" OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 141109)
-- Name: cpu_interrupt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_interrupt (
    id_cpu_interrupt integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_interrupt double precision DEFAULT 0.0 NOT NULL,
    time_value_cpu_interrupt timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_interrupt CHECK (((value_cpu_interrupt >= (0)::double precision) AND (value_cpu_interrupt <= (100)::double precision)))
);


ALTER TABLE public.cpu_interrupt OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 141114)
-- Name: cpu_interrupt_id_cpu_interrupt_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cpu_interrupt_id_cpu_interrupt_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cpu_interrupt_id_cpu_interrupt_seq OWNER TO postgres;

--
-- TOC entry 3231 (class 0 OID 0)
-- Dependencies: 201
-- Name: cpu_interrupt_id_cpu_interrupt_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_interrupt_id_cpu_interrupt_seq OWNED BY public.cpu_interrupt.id_cpu_interrupt;


--
-- TOC entry 203 (class 1259 OID 141121)
-- Name: cpu_lowait_id_cpu_lowait_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cpu_lowait_id_cpu_lowait_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cpu_lowait_id_cpu_lowait_seq OWNER TO postgres;

--
-- TOC entry 3232 (class 0 OID 0)
-- Dependencies: 203
-- Name: cpu_lowait_id_cpu_lowait_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_lowait_id_cpu_lowait_seq OWNED BY public."cpu_Iowait"."id_cpu_Iowait";


--
-- TOC entry 204 (class 1259 OID 141123)
-- Name: cpu_nice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_nice (
    id_cpu_nice integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_nice double precision DEFAULT 0.0 NOT NULL,
    time_value_cpu_nice timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_nice CHECK (((value_cpu_nice >= (0)::double precision) AND (value_cpu_nice <= (100)::double precision)))
);


ALTER TABLE public.cpu_nice OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 141128)
-- Name: cpu_nice_id_cpu_nice_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cpu_nice_id_cpu_nice_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cpu_nice_id_cpu_nice_seq OWNER TO postgres;

--
-- TOC entry 3233 (class 0 OID 0)
-- Dependencies: 205
-- Name: cpu_nice_id_cpu_nice_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_nice_id_cpu_nice_seq OWNED BY public.cpu_nice.id_cpu_nice;


--
-- TOC entry 206 (class 1259 OID 141130)
-- Name: cpu_softirq; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_softirq (
    id_cpu_softirq integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_softirq double precision DEFAULT 0.0 NOT NULL,
    time_value_cpu_softirq timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_softirq CHECK (((value_cpu_softirq >= (0)::double precision) AND (value_cpu_softirq <= (100)::double precision)))
);


ALTER TABLE public.cpu_softirq OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 141135)
-- Name: cpu_softirq_id_cpu_softirq_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cpu_softirq_id_cpu_softirq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cpu_softirq_id_cpu_softirq_seq OWNER TO postgres;

--
-- TOC entry 3234 (class 0 OID 0)
-- Dependencies: 207
-- Name: cpu_softirq_id_cpu_softirq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_softirq_id_cpu_softirq_seq OWNED BY public.cpu_softirq.id_cpu_softirq;


--
-- TOC entry 208 (class 1259 OID 141137)
-- Name: cpu_steal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_steal (
    id_cpu_steal integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_steal double precision DEFAULT 0.0 NOT NULL,
    time_value_cpu_steal timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_steal CHECK (((value_cpu_steal >= (0)::double precision) AND (value_cpu_steal <= (100)::double precision)))
);


ALTER TABLE public.cpu_steal OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 141142)
-- Name: cpu_steal_id_cpu_steal_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cpu_steal_id_cpu_steal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cpu_steal_id_cpu_steal_seq OWNER TO postgres;

--
-- TOC entry 3235 (class 0 OID 0)
-- Dependencies: 209
-- Name: cpu_steal_id_cpu_steal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_steal_id_cpu_steal_seq OWNED BY public.cpu_steal.id_cpu_steal;


--
-- TOC entry 210 (class 1259 OID 141144)
-- Name: cpu_system; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_system (
    id_cpu_system integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_system double precision DEFAULT 0.0 NOT NULL,
    time_value_cpu_system timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_system CHECK (((value_cpu_system >= (0)::double precision) AND (value_cpu_system <= (100)::double precision)))
);


ALTER TABLE public.cpu_system OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 141149)
-- Name: cpu_system_id_cpu_system_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cpu_system_id_cpu_system_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cpu_system_id_cpu_system_seq OWNER TO postgres;

--
-- TOC entry 3236 (class 0 OID 0)
-- Dependencies: 211
-- Name: cpu_system_id_cpu_system_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_system_id_cpu_system_seq OWNED BY public.cpu_system.id_cpu_system;


--
-- TOC entry 212 (class 1259 OID 141151)
-- Name: cpu_util_idle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_util_idle (
    id_cpu_util_idle integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_util_idle double precision DEFAULT 0.0 NOT NULL,
    time_value_cpu_util_idle timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_util_idle CHECK (((value_cpu_util_idle >= (0)::double precision) AND (value_cpu_util_idle <= (100)::double precision)))
);


ALTER TABLE public.cpu_util_idle OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 141156)
-- Name: cpu_util_idle_id_cpu_util_idle_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cpu_util_idle_id_cpu_util_idle_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cpu_util_idle_id_cpu_util_idle_seq OWNER TO postgres;

--
-- TOC entry 3237 (class 0 OID 0)
-- Dependencies: 213
-- Name: cpu_util_idle_id_cpu_util_idle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_util_idle_id_cpu_util_idle_seq OWNED BY public.cpu_util_idle.id_cpu_util_idle;


--
-- TOC entry 214 (class 1259 OID 141158)
-- Name: cpu_util_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_util_user (
    id_cpu_util_user integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_util_user double precision DEFAULT 0.0 NOT NULL,
    time_cpu_util_user timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_util_user CHECK (((value_cpu_util_user >= (0)::double precision) AND (value_cpu_util_user <= (100)::double precision)))
);


ALTER TABLE public.cpu_util_user OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 141163)
-- Name: cpu_util_user_id_cpu_util_user_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cpu_util_user_id_cpu_util_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cpu_util_user_id_cpu_util_user_seq OWNER TO postgres;

--
-- TOC entry 3238 (class 0 OID 0)
-- Dependencies: 215
-- Name: cpu_util_user_id_cpu_util_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_util_user_id_cpu_util_user_seq OWNED BY public.cpu_util_user.id_cpu_util_user;


--
-- TOC entry 216 (class 1259 OID 141165)
-- Name: history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.history (
    id_history integer NOT NULL,
    hostid integer,
    downtime timestamp without time zone NOT NULL,
    name_host character varying(255) NOT NULL
);


ALTER TABLE public.history OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 141168)
-- Name: host; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.host (
    hostid integer NOT NULL,
    name_host character varying,
    ip_host text[]
);


ALTER TABLE public.host OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 141174)
-- Name: memory_available; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.memory_available (
    id_memory_available integer NOT NULL,
    hostid integer NOT NULL,
    value_memory_available character varying(100) DEFAULT '0'::character varying NOT NULL,
    time_memory_available timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_memory_available CHECK (((value_memory_available)::text !~~ '%[^0-9]%'::text))
);


ALTER TABLE public.memory_available OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 141179)
-- Name: memory_total; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.memory_total (
    id_memory_total integer NOT NULL,
    hostid integer NOT NULL,
    value_memory_total character varying(100) DEFAULT '0'::character varying NOT NULL,
    time_memory_total timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_memory_total CHECK (((value_memory_total)::text !~~ '%[^0-9]%'::text))
);


ALTER TABLE public.memory_total OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 141184)
-- Name: percpu_avg1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.percpu_avg1 (
    id_percpu_avg1 integer NOT NULL,
    hostid integer NOT NULL,
    value_percpu_avg1 double precision DEFAULT 0.0 NOT NULL,
    time_percpu_avg1 timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_percpu_avg1 CHECK ((value_percpu_avg1 >= (0)::double precision))
);


ALTER TABLE public.percpu_avg1 OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 141189)
-- Name: percpu_avg15; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.percpu_avg15 (
    id_percpu_avg15 integer NOT NULL,
    hostid integer NOT NULL,
    value_percpu_avg15 double precision DEFAULT 0.0 NOT NULL,
    time_percpu_avg15 timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_percpu_avg15 CHECK ((value_percpu_avg15 >= (0)::double precision))
);


ALTER TABLE public.percpu_avg15 OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 141194)
-- Name: percpu_avg5; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.percpu_avg5 (
    id_percpu_avg5 integer NOT NULL,
    hostid integer NOT NULL,
    value_percpu_avg5 double precision DEFAULT 0.0 NOT NULL,
    time_percpu_avg5 timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_percpu_avg5 CHECK ((value_percpu_avg5 >= (0)::double precision))
);


ALTER TABLE public.percpu_avg5 OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 141199)
-- Name: size_free; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.size_free (
    id_size_free integer NOT NULL,
    hostid integer NOT NULL,
    value_size_free character varying(100) DEFAULT '0'::character varying NOT NULL,
    time_size_free timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_size_free CHECK (((value_size_free)::text !~~ '%[^0-9]%'::text))
);


ALTER TABLE public.size_free OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 141204)
-- Name: size_total; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.size_total (
    id_size_total integer NOT NULL,
    hostid integer NOT NULL,
    value_size_total character varying(100) DEFAULT '0'::character varying NOT NULL,
    time_size_total timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_size_total CHECK (((value_size_total)::text !~~ '%[^0-9]%'::text))
);


ALTER TABLE public.size_total OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 141209)
-- Name: host_info; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.host_info AS
 SELECT host.hostid,
    host.name_host,
    percpu_avg1.value_percpu_avg1,
    percpu_avg1.time_percpu_avg1,
    percpu_avg5.value_percpu_avg5,
    percpu_avg5.time_percpu_avg5,
    percpu_avg15.value_percpu_avg15,
    percpu_avg15.time_percpu_avg15,
    size_free.value_size_free,
    size_free.time_size_free,
    size_total.value_size_total,
    size_total.time_size_total,
    memory_available.value_memory_available,
    memory_available.time_memory_available,
    memory_total.value_memory_total,
    memory_total.time_memory_total,
    cpu_util_idle.value_cpu_util_idle,
    cpu_util_idle.time_value_cpu_util_idle,
    cpu_util_user.value_cpu_util_user,
    cpu_util_user.time_cpu_util_user
   FROM (((((((((public.host
     JOIN public.percpu_avg1 ON ((host.hostid = percpu_avg1.hostid)))
     JOIN public.percpu_avg5 ON ((host.hostid = percpu_avg5.hostid)))
     JOIN public.percpu_avg15 ON ((host.hostid = percpu_avg15.hostid)))
     JOIN public.size_free ON ((host.hostid = size_free.hostid)))
     JOIN public.size_total ON ((host.hostid = size_total.hostid)))
     JOIN public.memory_available ON ((host.hostid = memory_available.hostid)))
     JOIN public.memory_total ON ((host.hostid = memory_total.hostid)))
     JOIN public.cpu_util_idle ON ((host.hostid = cpu_util_idle.hostid)))
     JOIN public.cpu_util_user ON ((host.hostid = cpu_util_user.hostid)))
  WHERE ((percpu_avg1.time_percpu_avg1 = ( SELECT max(percpu_avg1_1.time_percpu_avg1) AS max
           FROM public.percpu_avg1 percpu_avg1_1)) AND (percpu_avg5.time_percpu_avg5 = ( SELECT max(percpu_avg5_1.time_percpu_avg5) AS max
           FROM public.percpu_avg5 percpu_avg5_1)) AND (percpu_avg15.time_percpu_avg15 = ( SELECT max(percpu_avg15_1.time_percpu_avg15) AS max
           FROM public.percpu_avg15 percpu_avg15_1)) AND (size_free.time_size_free = ( SELECT max(size_free_1.time_size_free) AS max
           FROM public.size_free size_free_1)) AND (size_total.time_size_total = ( SELECT max(size_total_1.time_size_total) AS max
           FROM public.size_total size_total_1)) AND (memory_available.time_memory_available = ( SELECT max(memory_available_1.time_memory_available) AS max
           FROM public.memory_available memory_available_1)) AND (memory_total.time_memory_total = ( SELECT max(memory_total_1.time_memory_total) AS max
           FROM public.memory_total memory_total_1)) AND (cpu_util_idle.time_value_cpu_util_idle = ( SELECT max(cpu_util_idle_1.time_value_cpu_util_idle) AS max
           FROM public.cpu_util_idle cpu_util_idle_1)) AND (cpu_util_user.time_cpu_util_user = ( SELECT max(cpu_util_user_1.time_cpu_util_user) AS max
           FROM public.cpu_util_user cpu_util_user_1)))
  ORDER BY percpu_avg5.time_percpu_avg5, percpu_avg15.time_percpu_avg15, percpu_avg1.time_percpu_avg1, size_free.time_size_free, size_total.time_size_total, memory_available.time_memory_available, memory_total.time_memory_total, cpu_util_idle.time_value_cpu_util_idle, cpu_util_user.time_cpu_util_user;


ALTER TABLE public.host_info OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 141214)
-- Name: host_work; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.host_work AS
 SELECT host_info.hostid,
    host_info.name_host,
    public.work_calculation(public.percent_size(host_info.value_size_free, host_info.value_size_total), public.percent_memory(host_info.value_memory_available, host_info.value_memory_total), host_info.value_cpu_util_user) AS work_calculation,
    host_info.time_size_free,
    host_info.time_size_total,
    host_info.time_memory_total,
    host_info.time_memory_available,
    host_info.time_cpu_util_user
   FROM public.host_info
  ORDER BY host_info.time_size_free, host_info.time_size_total, host_info.time_memory_total, host_info.time_memory_available, host_info.time_cpu_util_user;


ALTER TABLE public.host_work OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 141218)
-- Name: memory_available_id_memory_available_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.memory_available_id_memory_available_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.memory_available_id_memory_available_seq OWNER TO postgres;

--
-- TOC entry 3239 (class 0 OID 0)
-- Dependencies: 227
-- Name: memory_available_id_memory_available_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.memory_available_id_memory_available_seq OWNED BY public.memory_available.id_memory_available;


--
-- TOC entry 228 (class 1259 OID 141220)
-- Name: memory_total_id_memory_total_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.memory_total_id_memory_total_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.memory_total_id_memory_total_seq OWNER TO postgres;

--
-- TOC entry 3240 (class 0 OID 0)
-- Dependencies: 228
-- Name: memory_total_id_memory_total_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.memory_total_id_memory_total_seq OWNED BY public.memory_total.id_memory_total;


--
-- TOC entry 229 (class 1259 OID 141222)
-- Name: percpu_avg15_id_percpu_avg15_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.percpu_avg15_id_percpu_avg15_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.percpu_avg15_id_percpu_avg15_seq OWNER TO postgres;

--
-- TOC entry 3241 (class 0 OID 0)
-- Dependencies: 229
-- Name: percpu_avg15_id_percpu_avg15_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.percpu_avg15_id_percpu_avg15_seq OWNED BY public.percpu_avg15.id_percpu_avg15;


--
-- TOC entry 230 (class 1259 OID 141224)
-- Name: percpu_avg1_id_percpu_avg1_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.percpu_avg1_id_percpu_avg1_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.percpu_avg1_id_percpu_avg1_seq OWNER TO postgres;

--
-- TOC entry 3242 (class 0 OID 0)
-- Dependencies: 230
-- Name: percpu_avg1_id_percpu_avg1_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.percpu_avg1_id_percpu_avg1_seq OWNED BY public.percpu_avg1.id_percpu_avg1;


--
-- TOC entry 231 (class 1259 OID 141226)
-- Name: percpu_avg5_id_percpu_avg5_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.percpu_avg5_id_percpu_avg5_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.percpu_avg5_id_percpu_avg5_seq OWNER TO postgres;

--
-- TOC entry 3243 (class 0 OID 0)
-- Dependencies: 231
-- Name: percpu_avg5_id_percpu_avg5_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.percpu_avg5_id_percpu_avg5_seq OWNED BY public.percpu_avg5.id_percpu_avg5;


--
-- TOC entry 232 (class 1259 OID 141228)
-- Name: size_free_id_size_free_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.size_free_id_size_free_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.size_free_id_size_free_seq OWNER TO postgres;

--
-- TOC entry 3244 (class 0 OID 0)
-- Dependencies: 232
-- Name: size_free_id_size_free_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.size_free_id_size_free_seq OWNED BY public.size_free.id_size_free;


--
-- TOC entry 233 (class 1259 OID 141230)
-- Name: size_total_id_size_total_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.size_total_id_size_total_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.size_total_id_size_total_seq OWNER TO postgres;

--
-- TOC entry 3245 (class 0 OID 0)
-- Dependencies: 233
-- Name: size_total_id_size_total_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.size_total_id_size_total_seq OWNED BY public.size_total.id_size_total;


--
-- TOC entry 3006 (class 2604 OID 148757)
-- Name: User id_user; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User" ALTER COLUMN id_user SET DEFAULT nextval('public."User_id_user_seq"'::regclass);


--
-- TOC entry 2965 (class 2604 OID 141233)
-- Name: cpu_Iowait id_cpu_Iowait; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."cpu_Iowait" ALTER COLUMN "id_cpu_Iowait" SET DEFAULT nextval('public.cpu_lowait_id_cpu_lowait_seq'::regclass);


--
-- TOC entry 2962 (class 2604 OID 141232)
-- Name: cpu_interrupt id_cpu_interrupt; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_interrupt ALTER COLUMN id_cpu_interrupt SET DEFAULT nextval('public.cpu_interrupt_id_cpu_interrupt_seq'::regclass);


--
-- TOC entry 2968 (class 2604 OID 141234)
-- Name: cpu_nice id_cpu_nice; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_nice ALTER COLUMN id_cpu_nice SET DEFAULT nextval('public.cpu_nice_id_cpu_nice_seq'::regclass);


--
-- TOC entry 2971 (class 2604 OID 141235)
-- Name: cpu_softirq id_cpu_softirq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_softirq ALTER COLUMN id_cpu_softirq SET DEFAULT nextval('public.cpu_softirq_id_cpu_softirq_seq'::regclass);


--
-- TOC entry 2974 (class 2604 OID 141236)
-- Name: cpu_steal id_cpu_steal; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_steal ALTER COLUMN id_cpu_steal SET DEFAULT nextval('public.cpu_steal_id_cpu_steal_seq'::regclass);


--
-- TOC entry 2977 (class 2604 OID 141237)
-- Name: cpu_system id_cpu_system; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_system ALTER COLUMN id_cpu_system SET DEFAULT nextval('public.cpu_system_id_cpu_system_seq'::regclass);


--
-- TOC entry 2980 (class 2604 OID 141238)
-- Name: cpu_util_idle id_cpu_util_idle; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_util_idle ALTER COLUMN id_cpu_util_idle SET DEFAULT nextval('public.cpu_util_idle_id_cpu_util_idle_seq'::regclass);


--
-- TOC entry 2983 (class 2604 OID 141239)
-- Name: cpu_util_user id_cpu_util_user; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_util_user ALTER COLUMN id_cpu_util_user SET DEFAULT nextval('public.cpu_util_user_id_cpu_util_user_seq'::regclass);


--
-- TOC entry 2986 (class 2604 OID 141240)
-- Name: memory_available id_memory_available; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_available ALTER COLUMN id_memory_available SET DEFAULT nextval('public.memory_available_id_memory_available_seq'::regclass);


--
-- TOC entry 2989 (class 2604 OID 141241)
-- Name: memory_total id_memory_total; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_total ALTER COLUMN id_memory_total SET DEFAULT nextval('public.memory_total_id_memory_total_seq'::regclass);


--
-- TOC entry 2992 (class 2604 OID 141242)
-- Name: percpu_avg1 id_percpu_avg1; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg1 ALTER COLUMN id_percpu_avg1 SET DEFAULT nextval('public.percpu_avg1_id_percpu_avg1_seq'::regclass);


--
-- TOC entry 2995 (class 2604 OID 141243)
-- Name: percpu_avg15 id_percpu_avg15; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg15 ALTER COLUMN id_percpu_avg15 SET DEFAULT nextval('public.percpu_avg15_id_percpu_avg15_seq'::regclass);


--
-- TOC entry 2998 (class 2604 OID 141244)
-- Name: percpu_avg5 id_percpu_avg5; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg5 ALTER COLUMN id_percpu_avg5 SET DEFAULT nextval('public.percpu_avg5_id_percpu_avg5_seq'::regclass);


--
-- TOC entry 3001 (class 2604 OID 141245)
-- Name: size_free id_size_free; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_free ALTER COLUMN id_size_free SET DEFAULT nextval('public.size_free_id_size_free_seq'::regclass);


--
-- TOC entry 3004 (class 2604 OID 141246)
-- Name: size_total id_size_total; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_total ALTER COLUMN id_size_total SET DEFAULT nextval('public.size_total_id_size_total_seq'::regclass);


--
-- TOC entry 3224 (class 0 OID 148754)
-- Dependencies: 235
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id_user, surname, name, patronymic, login, password) FROM stdin;
1	TestSurname	TestName	TestPatronymic	123	6875723739323868726f69666e77727669646f687563696779373833393866716568636477696e6f40bd001563085fc35165329ea1ff5c5ecbdbbeef
\.


--
-- TOC entry 3193 (class 0 OID 141116)
-- Dependencies: 202
-- Data for Name: cpu_Iowait; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."cpu_Iowait" ("id_cpu_Iowait", hostid, "value_cpu_Iowait", "time_value_cpu_Iowait") FROM stdin;
241	10132	0	2023-03-19 12:00:30
242	10147	0	2023-03-19 12:00:30
243	10130	0	2023-03-19 12:00:30
244	10150	0	2023-03-19 12:00:30
245	10156	0	2023-03-19 12:00:30
246	10142	0	2023-03-19 12:00:30
247	10139	0	2023-03-19 12:00:31
248	10120	0	2023-03-19 12:00:31
249	10152	0	2023-03-19 12:00:31
250	10131	0	2023-03-19 12:00:31
251	10144	0	2023-03-19 12:00:31
252	10134	0	2023-03-19 12:00:31
253	10133	0	2023-03-19 12:00:32
254	10121	0	2023-03-19 12:00:32
255	10154	0	2023-03-19 12:00:32
256	10153	0	2023-03-19 12:00:32
257	10140	0	2023-03-19 12:00:32
258	10157	0	2023-03-19 12:00:33
259	10126	0	2023-03-19 12:00:33
260	10125	0	2023-03-19 12:00:33
261	10138	0	2023-03-19 12:00:33
262	10124	0	2023-03-19 12:00:33
263	10141	0	2023-03-19 12:00:34
264	10135	0	2023-03-19 12:00:34
265	10123	0	2023-03-19 12:00:34
266	10084	0.017	2023-03-19 12:00:34
267	10155	0	2023-03-19 12:00:34
268	10148	0	2023-03-19 12:00:34
269	10137	0	2023-03-19 12:00:35
270	10129	0	2023-03-19 12:00:35
271	10122	0	2023-03-19 12:00:35
272	10146	0	2023-03-19 12:00:35
273	10136	0	2023-03-19 12:00:35
274	10145	0	2023-03-19 12:00:36
275	10143	0	2023-03-19 12:00:36
276	10119	0	2023-03-19 12:00:36
277	10128	0	2023-03-19 12:00:36
278	10149	0	2023-03-19 12:00:36
279	10151	0	2023-03-19 12:00:37
280	10127	0	2023-03-19 12:00:37
\.


--
-- TOC entry 3191 (class 0 OID 141109)
-- Dependencies: 200
-- Data for Name: cpu_interrupt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_interrupt (id_cpu_interrupt, hostid, value_cpu_interrupt, time_value_cpu_interrupt) FROM stdin;
241	10132	0	2023-03-19 12:00:22
242	10147	0	2023-03-19 12:00:23
243	10130	0	2023-03-19 12:00:23
244	10150	0	2023-03-19 12:00:23
245	10156	0	2023-03-19 12:00:23
246	10142	0	2023-03-19 12:00:23
247	10139	0	2023-03-19 12:00:24
248	10120	0	2023-03-19 12:00:24
249	10152	0	2023-03-19 12:00:24
250	10131	0	2023-03-19 12:00:24
251	10144	0	2023-03-19 12:00:24
252	10134	0	2023-03-19 12:00:24
253	10133	0	2023-03-19 12:00:25
254	10121	0	2023-03-19 12:00:25
255	10154	0	2023-03-19 12:00:25
256	10153	0	2023-03-19 12:00:25
257	10140	0	2023-03-19 12:00:25
258	10157	0	2023-03-19 12:00:26
259	10126	0	2023-03-19 12:00:26
260	10125	0	2023-03-19 12:00:26
261	10138	0	2023-03-19 12:00:26
262	10124	0	2023-03-19 12:00:26
263	10141	0	2023-03-19 12:00:26
264	10135	0	2023-03-19 12:00:27
265	10123	0	2023-03-19 12:00:27
266	10084	0	2023-03-19 12:00:27
267	10155	0	2023-03-19 12:00:27
268	10148	0	2023-03-19 12:00:27
269	10137	0	2023-03-19 12:00:27
270	10129	0	2023-03-19 12:00:28
271	10122	0	2023-03-19 12:00:28
272	10146	0	2023-03-19 12:00:28
273	10136	0	2023-03-19 12:00:28
274	10145	0	2023-03-19 12:00:28
275	10143	0	2023-03-19 12:00:29
276	10119	0	2023-03-19 12:00:29
277	10128	0	2023-03-19 12:00:29
278	10149	0	2023-03-19 12:00:29
279	10151	0	2023-03-19 12:00:29
280	10127	0	2023-03-19 12:00:29
\.


--
-- TOC entry 3195 (class 0 OID 141123)
-- Dependencies: 204
-- Data for Name: cpu_nice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_nice (id_cpu_nice, hostid, value_cpu_nice, time_value_cpu_nice) FROM stdin;
241	10132	0	2023-03-19 12:00:37
242	10147	0	2023-03-19 12:00:37
243	10130	0	2023-03-19 12:00:37
244	10150	0	2023-03-19 12:00:37
245	10156	0	2023-03-19 12:00:38
246	10142	0	2023-03-19 12:00:38
247	10139	0	2023-03-19 12:00:38
248	10120	0	2023-03-19 12:00:38
249	10152	0	2023-03-19 12:00:38
250	10131	0	2023-03-19 12:00:39
251	10144	0	2023-03-19 12:00:39
252	10134	0	2023-03-19 12:00:39
253	10133	0	2023-03-19 12:00:39
254	10121	0	2023-03-19 12:00:39
255	10154	0	2023-03-19 12:00:39
256	10153	0	2023-03-19 12:00:40
257	10140	0	2023-03-19 12:00:40
258	10157	0	2023-03-19 12:00:40
259	10126	0	2023-03-19 12:00:40
260	10125	0	2023-03-19 12:00:40
261	10138	0	2023-03-19 12:00:40
262	10124	0	2023-03-19 12:00:41
263	10141	0	2023-03-19 12:00:41
264	10135	0	2023-03-19 12:00:41
265	10123	0	2023-03-19 12:00:41
266	10084	0	2023-03-19 12:00:41
267	10155	0	2023-03-19 12:00:42
268	10148	0	2023-03-19 12:00:42
269	10137	0	2023-03-19 12:00:42
270	10129	0	2023-03-19 12:00:42
271	10122	0	2023-03-19 12:00:42
272	10146	0	2023-03-19 12:00:42
273	10136	0	2023-03-19 12:00:43
274	10145	0	2023-03-19 12:00:43
275	10143	0	2023-03-19 12:00:43
276	10119	0	2023-03-19 12:00:43
277	10128	0	2023-03-19 12:00:43
278	10149	0	2023-03-19 12:00:43
279	10151	0	2023-03-19 12:00:44
280	10127	0	2023-03-19 12:00:44
\.


--
-- TOC entry 3197 (class 0 OID 141130)
-- Dependencies: 206
-- Data for Name: cpu_softirq; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_softirq (id_cpu_softirq, hostid, value_cpu_softirq, time_value_cpu_softirq) FROM stdin;
241	10132	0	2023-03-19 12:00:44
242	10147	0	2023-03-19 12:00:44
243	10130	0	2023-03-19 12:00:44
244	10150	0	2023-03-19 12:00:45
245	10156	0	2023-03-19 12:00:45
246	10142	0	2023-03-19 12:00:45
247	10139	0	2023-03-19 12:00:45
248	10120	0	2023-03-19 12:00:45
249	10152	0	2023-03-19 12:00:45
250	10131	0	2023-03-19 12:00:46
251	10144	0	2023-03-19 12:00:46
252	10134	0	2023-03-19 12:00:46
253	10133	0	2023-03-19 12:00:46
254	10121	0	2023-03-19 12:00:46
255	10154	0	2023-03-19 12:00:46
256	10153	0	2023-03-19 12:00:47
257	10140	0	2023-03-19 12:00:47
258	10157	0	2023-03-19 12:00:47
259	10126	0	2023-03-19 12:00:47
260	10125	0	2023-03-19 12:00:47
261	10138	0	2023-03-19 12:00:48
262	10124	0	2023-03-19 12:00:48
263	10141	0	2023-03-19 12:00:48
264	10135	0	2023-03-19 12:00:48
265	10123	0	2023-03-19 12:00:48
266	10084	0.101	2023-03-19 12:00:48
267	10155	0	2023-03-19 12:00:49
268	10148	0	2023-03-19 12:00:49
269	10137	0	2023-03-19 12:00:49
270	10129	0	2023-03-19 12:00:49
271	10122	0	2023-03-19 12:00:49
272	10146	0	2023-03-19 12:00:49
273	10136	0	2023-03-19 12:00:50
274	10145	0	2023-03-19 12:00:50
275	10143	0	2023-03-19 12:00:50
276	10119	0	2023-03-19 12:00:50
277	10128	0	2023-03-19 12:00:50
278	10149	0	2023-03-19 12:00:50
279	10151	0	2023-03-19 12:00:51
280	10127	0	2023-03-19 12:00:51
\.


--
-- TOC entry 3199 (class 0 OID 141137)
-- Dependencies: 208
-- Data for Name: cpu_steal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_steal (id_cpu_steal, hostid, value_cpu_steal, time_value_cpu_steal) FROM stdin;
241	10132	0	2023-03-19 12:00:51
242	10147	0	2023-03-19 12:00:51
243	10130	0	2023-03-19 12:00:51
244	10150	0	2023-03-19 12:00:52
245	10156	0	2023-03-19 12:00:52
246	10142	0	2023-03-19 12:00:52
247	10139	0	2023-03-19 12:00:52
248	10120	0	2023-03-19 12:00:52
249	10152	0	2023-03-19 12:00:52
250	10131	0	2023-03-19 12:00:53
251	10144	0	2023-03-19 12:00:53
252	10134	0	2023-03-19 12:00:53
253	10133	0	2023-03-19 12:00:53
254	10121	0	2023-03-19 12:00:53
255	10154	0	2023-03-19 12:00:53
256	10153	0	2023-03-19 12:00:54
257	10140	0	2023-03-19 12:00:54
258	10157	0	2023-03-19 12:00:54
259	10126	0	2023-03-19 12:00:54
260	10125	0	2023-03-19 12:00:54
261	10138	0	2023-03-19 12:00:55
262	10124	0	2023-03-19 12:00:55
263	10141	0	2023-03-19 12:00:55
264	10135	0	2023-03-19 12:00:55
265	10123	0	2023-03-19 12:00:55
266	10084	0	2023-03-19 12:00:55
267	10155	0	2023-03-19 12:00:56
268	10148	0	2023-03-19 12:00:56
269	10137	0	2023-03-19 12:00:56
270	10129	0	2023-03-19 12:00:56
271	10122	0	2023-03-19 12:00:56
272	10146	0	2023-03-19 12:00:56
273	10136	0	2023-03-19 12:00:57
274	10145	0	2023-03-19 12:00:57
275	10143	0	2023-03-19 12:00:57
276	10119	0	2023-03-19 12:00:57
277	10128	0	2023-03-19 12:00:57
278	10149	0	2023-03-19 12:00:58
279	10151	0	2023-03-19 12:00:58
280	10127	0	2023-03-19 12:00:58
\.


--
-- TOC entry 3201 (class 0 OID 141144)
-- Dependencies: 210
-- Data for Name: cpu_system; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_system (id_cpu_system, hostid, value_cpu_system, time_value_cpu_system) FROM stdin;
241	10132	0	2023-03-19 12:00:58
242	10147	0	2023-03-19 12:00:58
243	10130	0	2023-03-19 12:00:58
244	10150	0	2023-03-19 12:00:59
245	10156	0	2023-03-19 12:00:59
246	10142	0	2023-03-19 12:00:59
247	10139	0	2023-03-19 12:00:59
248	10120	0	2023-03-19 12:00:59
249	10152	0	2023-03-19 12:00:59
250	10131	0	2023-03-19 12:01:00
251	10144	0	2023-03-19 12:01:00
252	10134	0	2023-03-19 12:01:00
253	10133	0	2023-03-19 12:01:00
254	10121	0	2023-03-19 12:01:00
255	10154	0	2023-03-19 12:01:01
256	10153	0	2023-03-19 12:01:01
257	10140	0	2023-03-19 12:01:01
258	10157	0	2023-03-19 12:01:01
259	10126	0	2023-03-19 12:01:01
260	10125	0	2023-03-19 12:01:01
261	10138	0	2023-03-19 12:01:02
262	10124	0	2023-03-19 12:01:02
263	10141	0	2023-03-19 12:01:02
264	10135	0	2023-03-19 12:01:02
265	10123	0	2023-03-19 12:01:02
266	10084	3.68	2023-03-19 12:01:03
267	10155	0	2023-03-19 12:01:03
268	10148	0	2023-03-19 12:01:03
269	10137	0	2023-03-19 12:01:03
270	10129	0	2023-03-19 12:01:03
271	10122	0	2023-03-19 12:01:03
272	10146	0	2023-03-19 12:01:04
273	10136	0	2023-03-19 12:01:04
274	10145	0	2023-03-19 12:01:04
275	10143	0	2023-03-19 12:01:04
276	10119	0	2023-03-19 12:01:04
277	10128	0	2023-03-19 12:01:04
278	10149	0	2023-03-19 12:01:05
279	10151	0	2023-03-19 12:01:05
280	10127	0	2023-03-19 12:01:05
\.


--
-- TOC entry 3203 (class 0 OID 141151)
-- Dependencies: 212
-- Data for Name: cpu_util_idle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_util_idle (id_cpu_util_idle, hostid, value_cpu_util_idle, time_value_cpu_util_idle) FROM stdin;
357	10132	0	2023-03-19 12:00:15
358	10147	0	2023-03-19 12:00:15
359	10130	0	2023-03-19 12:00:15
360	10150	0	2023-03-19 12:00:16
361	10156	0	2023-03-19 12:00:16
362	10142	0	2023-03-19 12:00:16
363	10139	0	2023-03-19 12:00:16
364	10120	0	2023-03-19 12:00:16
365	10152	0	2023-03-19 12:00:17
366	10131	0	2023-03-19 12:00:17
367	10144	0	2023-03-19 12:00:17
368	10134	0	2023-03-19 12:00:17
369	10133	0	2023-03-19 12:00:17
370	10121	0	2023-03-19 12:00:17
371	10154	0	2023-03-19 12:00:18
372	10153	0	2023-03-19 12:00:18
373	10140	0	2023-03-19 12:00:18
374	10157	0	2023-03-19 12:00:18
375	10126	0	2023-03-19 12:00:18
376	10125	0	2023-03-19 12:00:19
377	10138	0	2023-03-19 12:00:19
378	10124	0	2023-03-19 12:00:19
379	10141	0	2023-03-19 12:00:19
380	10135	0	2023-03-19 12:00:19
381	10123	0	2023-03-19 12:00:20
382	10084	45.848	2023-03-19 12:00:20
383	10155	0	2023-03-19 12:00:20
384	10148	0	2023-03-19 12:00:20
385	10137	0	2023-03-19 12:00:20
386	10129	0	2023-03-19 12:00:21
387	10122	0	2023-03-19 12:00:21
388	10146	0	2023-03-19 12:00:21
389	10136	0	2023-03-19 12:00:21
390	10145	0	2023-03-19 12:00:21
391	10143	0	2023-03-19 12:00:21
392	10119	0	2023-03-19 12:00:22
393	10128	0	2023-03-19 12:00:22
394	10149	0	2023-03-19 12:00:22
395	10151	0	2023-03-19 12:00:22
396	10127	0	2023-03-19 12:00:22
\.


--
-- TOC entry 3205 (class 0 OID 141158)
-- Dependencies: 214
-- Data for Name: cpu_util_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_util_user (id_cpu_util_user, hostid, value_cpu_util_user, time_cpu_util_user) FROM stdin;
357	10132	0	2023-03-19 12:00:08
358	10147	0	2023-03-19 12:00:08
359	10130	0	2023-03-19 12:00:08
360	10150	0	2023-03-19 12:00:09
361	10156	0	2023-03-19 12:00:09
362	10142	0	2023-03-19 12:00:09
363	10139	0	2023-03-19 12:00:09
364	10120	0	2023-03-19 12:00:09
365	10152	0	2023-03-19 12:00:09
366	10131	0	2023-03-19 12:00:10
367	10144	0	2023-03-19 12:00:10
368	10134	0	2023-03-19 12:00:10
369	10133	0	2023-03-19 12:00:10
370	10121	0	2023-03-19 12:00:10
371	10154	0	2023-03-19 12:00:10
372	10153	0	2023-03-19 12:00:11
373	10140	0	2023-03-19 12:00:11
374	10157	0	2023-03-19 12:00:11
375	10126	0	2023-03-19 12:00:11
376	10125	0	2023-03-19 12:00:11
377	10138	0	2023-03-19 12:00:12
378	10124	0	2023-03-19 12:00:12
379	10141	0	2023-03-19 12:00:12
380	10135	0	2023-03-19 12:00:12
381	10123	0	2023-03-19 12:00:12
382	10084	0.3245	2023-03-19 12:00:12
383	10155	0	2023-03-19 12:00:13
384	10148	0	2023-03-19 12:00:13
385	10137	0	2023-03-19 12:00:13
386	10129	0	2023-03-19 12:00:13
387	10122	0	2023-03-19 12:00:13
388	10146	0	2023-03-19 12:00:13
389	10136	0	2023-03-19 12:00:14
390	10145	0	2023-03-19 12:00:14
391	10143	0	2023-03-19 12:00:14
392	10119	0	2023-03-19 12:00:14
393	10128	0	2023-03-19 12:00:14
394	10149	0	2023-03-19 12:00:15
395	10151	0	2023-03-19 12:00:15
396	10127	0	2023-03-19 12:00:15
\.


--
-- TOC entry 3207 (class 0 OID 141165)
-- Dependencies: 216
-- Data for Name: history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.history (id_history, hostid, downtime, name_host) FROM stdin;
\.


--
-- TOC entry 3208 (class 0 OID 141168)
-- Dependencies: 217
-- Data for Name: host; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.host (hostid, name_host, ip_host) FROM stdin;
10132	ARM13	{192.168.42.213}
10147	ARM29	{192.168.42.244}
10130	ARM11	{192.168.42.211}
10150	ARM32	{192.168.42.232}
10156	CC3	{192.168.42.248}
10142	ARM24	{192.168.42.224}
10139	ARM21	{192.168.42.221}
10120	ARM02	{192.168.42.202}
10152	CC1	{192.168.42.217}
10131	ARM12	{192.168.42.212}
10144	ARM26	{192.168.42.226}
10134	ARM15	{192.168.42.215}
10133	ARM14	{192.168.42.214}
10121	ARM03	{192.168.42.203}
10154	MC4	{192.168.42.243}
10153	MC3	{192.168.42.252}
10140	ARM22	{192.168.42.222}
10157	CC4	{192.168.42.249}
10126	ARM17	{192.168.42.246}
10125	ARM07	{192.168.42.207}
10138	ARM20	{192.168.42.220}
10124	ARM06	{192.168.42.206}
10141	ARM23	{192.168.42.223}
10135	ARM16	{192.168.42.245}
10123	ARM05	{192.168.42.205}
10084	MC1	{192.168.42.200,127.0.0.1}
10155	CC2	{192.168.42.218}
10148	ARM30	{192.168.42.230}
10137	ARM19	{192.168.42.219}
10129	ARM10	{192.168.42.210}
10122	ARM04	{192.168.42.204}
10146	ARM28	{192.168.42.243}
10136	ARM18	{192.168.42.247}
10145	ARM27	{192.168.42.242}
10143	ARM25	{192.168.42.225}
10119	ARM01	{192.168.42.201}
10128	ARM09	{192.168.42.209}
10149	ARM31	{192.168.42.231}
10151	MC2	{192.168.42.216}
10127	ARM08	{192.168.42.208}
\.


--
-- TOC entry 3209 (class 0 OID 141174)
-- Dependencies: 218
-- Data for Name: memory_available; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.memory_available (id_memory_available, hostid, value_memory_available, time_memory_available) FROM stdin;
352	10132	0	2023-03-19 12:01:19
353	10147	0	2023-03-19 12:01:20
354	10130	0	2023-03-19 12:01:20
355	10150	0	2023-03-19 12:01:20
356	10156	0	2023-03-19 12:01:20
357	10142	0	2023-03-19 12:01:20
358	10139	0	2023-03-19 12:01:20
359	10120	0	2023-03-19 12:01:21
360	10152	0	2023-03-19 12:01:21
361	10131	0	2023-03-19 12:01:21
362	10144	0	2023-03-19 12:01:21
363	10134	0	2023-03-19 12:01:21
364	10133	0	2023-03-19 12:01:22
365	10121	0	2023-03-19 12:01:22
366	10154	0	2023-03-19 12:01:22
367	10153	0	2023-03-19 12:01:22
368	10140	0	2023-03-19 12:01:22
369	10157	0	2023-03-19 12:01:22
370	10126	0	2023-03-19 12:01:23
371	10125	0	2023-03-19 12:01:23
372	10138	0	2023-03-19 12:01:23
373	10124	0	2023-03-19 12:01:23
374	10141	0	2023-03-19 12:01:23
375	10135	0	2023-03-19 12:01:23
376	10123	0	2023-03-19 12:01:24
377	10084	1729716224	2023-03-19 12:01:24
378	10155	0	2023-03-19 12:01:24
379	10148	0	2023-03-19 12:01:24
380	10137	0	2023-03-19 12:01:24
381	10129	0	2023-03-19 12:01:25
382	10122	0	2023-03-19 12:01:25
383	10146	0	2023-03-19 12:01:25
384	10136	0	2023-03-19 12:01:25
385	10145	0	2023-03-19 12:01:25
386	10143	0	2023-03-19 12:01:25
387	10119	0	2023-03-19 12:01:26
388	10128	0	2023-03-19 12:01:26
389	10149	0	2023-03-19 12:01:26
390	10151	0	2023-03-19 12:01:26
391	10127	0	2023-03-19 12:01:26
\.


--
-- TOC entry 3210 (class 0 OID 141179)
-- Dependencies: 219
-- Data for Name: memory_total; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.memory_total (id_memory_total, hostid, value_memory_total, time_memory_total) FROM stdin;
352	10132	0	2023-03-19 12:01:27
353	10147	0	2023-03-19 12:01:27
354	10130	0	2023-03-19 12:01:27
355	10150	0	2023-03-19 12:01:27
356	10156	0	2023-03-19 12:01:27
357	10142	0	2023-03-19 12:01:27
358	10139	0	2023-03-19 12:01:28
359	10120	0	2023-03-19 12:01:28
360	10152	0	2023-03-19 12:01:28
361	10131	0	2023-03-19 12:01:28
362	10144	0	2023-03-19 12:01:28
363	10134	0	2023-03-19 12:01:29
364	10133	0	2023-03-19 12:01:29
365	10121	0	2023-03-19 12:01:29
366	10154	0	2023-03-19 12:01:29
367	10153	0	2023-03-19 12:01:29
368	10140	0	2023-03-19 12:01:29
369	10157	0	2023-03-19 12:01:30
370	10126	0	2023-03-19 12:01:30
371	10125	0	2023-03-19 12:01:30
372	10138	0	2023-03-19 12:01:30
373	10124	0	2023-03-19 12:01:30
374	10141	0	2023-03-19 12:01:31
375	10135	0	2023-03-19 12:01:31
376	10123	0	2023-03-19 12:01:31
377	10084	2095120384	2023-03-19 12:01:31
378	10155	0	2023-03-19 12:01:31
379	10148	0	2023-03-19 12:01:32
380	10137	0	2023-03-19 12:01:32
381	10129	0	2023-03-19 12:01:32
382	10122	0	2023-03-19 12:01:32
383	10146	0	2023-03-19 12:01:33
384	10136	0	2023-03-19 12:01:33
385	10145	0	2023-03-19 12:01:33
386	10143	0	2023-03-19 12:01:34
387	10119	0	2023-03-19 12:01:34
388	10128	0	2023-03-19 12:01:34
389	10149	0	2023-03-19 12:01:34
390	10151	0	2023-03-19 12:01:34
391	10127	0	2023-03-19 12:01:34
\.


--
-- TOC entry 3211 (class 0 OID 141184)
-- Dependencies: 220
-- Data for Name: percpu_avg1; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.percpu_avg1 (id_percpu_avg1, hostid, value_percpu_avg1, time_percpu_avg1) FROM stdin;
357	10132	0	2023-03-19 12:00:01
358	10147	0	2023-03-19 12:00:01
359	10130	0	2023-03-19 12:00:01
360	10150	0	2023-03-19 12:00:01
361	10156	0	2023-03-19 12:00:02
362	10142	0	2023-03-19 12:00:02
363	10139	0	2023-03-19 12:00:02
364	10120	0	2023-03-19 12:00:02
365	10152	0	2023-03-19 12:00:02
366	10131	0	2023-03-19 12:00:02
367	10144	0	2023-03-19 12:00:03
368	10134	0	2023-03-19 12:00:03
369	10133	0	2023-03-19 12:00:03
370	10121	0	2023-03-19 12:00:03
371	10154	0	2023-03-19 12:00:03
372	10153	0	2023-03-19 12:00:03
373	10140	0	2023-03-19 12:00:04
374	10157	0	2023-03-19 12:00:04
375	10126	0	2023-03-19 12:00:04
376	10125	0	2023-03-19 12:00:04
377	10138	0	2023-03-19 12:00:04
378	10124	0	2023-03-19 12:00:05
379	10141	0	2023-03-19 12:00:05
380	10135	0	2023-03-19 12:00:05
381	10123	0	2023-03-19 12:00:05
382	10084	0.22	2023-03-19 12:00:05
383	10155	0	2023-03-19 12:00:05
384	10148	0	2023-03-19 12:00:06
385	10137	0	2023-03-19 12:00:06
386	10129	0	2023-03-19 12:00:06
387	10122	0	2023-03-19 12:00:06
388	10146	0	2023-03-19 12:00:06
389	10136	0	2023-03-19 12:00:07
390	10145	0	2023-03-19 12:00:07
391	10143	0	2023-03-19 12:00:07
392	10119	0	2023-03-19 12:00:07
393	10128	0	2023-03-19 12:00:07
394	10149	0	2023-03-19 12:00:07
395	10151	0	2023-03-19 12:00:08
396	10127	0	2023-03-19 12:00:08
\.


--
-- TOC entry 3212 (class 0 OID 141189)
-- Dependencies: 221
-- Data for Name: percpu_avg15; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.percpu_avg15 (id_percpu_avg15, hostid, value_percpu_avg15, time_percpu_avg15) FROM stdin;
397	10132	0	2023-03-19 11:59:47
398	10147	0	2023-03-19 11:59:47
399	10130	0	2023-03-19 11:59:47
400	10150	0	2023-03-19 11:59:47
401	10156	0	2023-03-19 11:59:47
402	10142	0	2023-03-19 11:59:48
403	10139	0	2023-03-19 11:59:48
404	10120	0	2023-03-19 11:59:48
405	10152	0	2023-03-19 11:59:48
406	10131	0	2023-03-19 11:59:48
407	10144	0	2023-03-19 11:59:48
408	10134	0	2023-03-19 11:59:49
409	10133	0	2023-03-19 11:59:49
410	10121	0	2023-03-19 11:59:49
411	10154	0	2023-03-19 11:59:49
412	10153	0	2023-03-19 11:59:49
413	10140	0	2023-03-19 11:59:49
414	10157	0	2023-03-19 11:59:50
415	10126	0	2023-03-19 11:59:50
416	10125	0	2023-03-19 11:59:50
417	10138	0	2023-03-19 11:59:50
418	10124	0	2023-03-19 11:59:50
419	10141	0	2023-03-19 11:59:51
420	10135	0	2023-03-19 11:59:51
421	10123	0	2023-03-19 11:59:51
422	10084	0.48	2023-03-19 11:59:51
423	10155	0	2023-03-19 11:59:51
424	10148	0	2023-03-19 11:59:51
425	10137	0	2023-03-19 11:59:52
426	10129	0	2023-03-19 11:59:52
427	10122	0	2023-03-19 11:59:52
428	10146	0	2023-03-19 11:59:52
429	10136	0	2023-03-19 11:59:52
430	10145	0	2023-03-19 11:59:52
431	10143	0	2023-03-19 11:59:53
432	10119	0	2023-03-19 11:59:53
433	10128	0	2023-03-19 11:59:53
434	10149	0	2023-03-19 11:59:53
435	10151	0	2023-03-19 11:59:53
436	10127	0	2023-03-19 11:59:54
\.


--
-- TOC entry 3213 (class 0 OID 141194)
-- Dependencies: 222
-- Data for Name: percpu_avg5; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.percpu_avg5 (id_percpu_avg5, hostid, value_percpu_avg5, time_percpu_avg5) FROM stdin;
357	10132	0	2023-03-19 11:59:54
358	10147	0	2023-03-19 11:59:54
359	10130	0	2023-03-19 11:59:54
360	10150	0	2023-03-19 11:59:54
361	10156	0	2023-03-19 11:59:54
362	10142	0	2023-03-19 11:59:55
363	10139	0	2023-03-19 11:59:55
364	10120	0	2023-03-19 11:59:55
365	10152	0	2023-03-19 11:59:55
366	10131	0	2023-03-19 11:59:55
367	10144	0	2023-03-19 11:59:56
368	10134	0	2023-03-19 11:59:56
369	10133	0	2023-03-19 11:59:56
370	10121	0	2023-03-19 11:59:56
371	10154	0	2023-03-19 11:59:56
372	10153	0	2023-03-19 11:59:56
373	10140	0	2023-03-19 11:59:57
374	10157	0	2023-03-19 11:59:57
375	10126	0	2023-03-19 11:59:57
376	10125	0	2023-03-19 11:59:57
377	10138	0	2023-03-19 11:59:57
378	10124	0	2023-03-19 11:59:57
379	10141	0	2023-03-19 11:59:58
380	10135	0	2023-03-19 11:59:58
381	10123	0	2023-03-19 11:59:58
382	10084	0.53	2023-03-19 11:59:58
383	10155	0	2023-03-19 11:59:58
384	10148	0	2023-03-19 11:59:59
385	10137	0	2023-03-19 11:59:59
386	10129	0	2023-03-19 11:59:59
387	10122	0	2023-03-19 11:59:59
388	10146	0	2023-03-19 11:59:59
389	10136	0	2023-03-19 11:59:59
390	10145	0	2023-03-19 12:00:00
391	10143	0	2023-03-19 12:00:00
392	10119	0	2023-03-19 12:00:00
393	10128	0	2023-03-19 12:00:00
394	10149	0	2023-03-19 12:00:00
395	10151	0	2023-03-19 12:00:00
396	10127	0	2023-03-19 12:00:01
\.


--
-- TOC entry 3214 (class 0 OID 141199)
-- Dependencies: 223
-- Data for Name: size_free; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.size_free (id_size_free, hostid, value_size_free, time_size_free) FROM stdin;
133	10132	0	2023-03-19 12:01:05
134	10130	0	2023-03-19 12:01:05
135	10120	0	2023-03-19 12:01:06
136	10152	0	2023-03-19 12:01:07
137	10131	0	2023-03-19 12:01:07
138	10134	0	2023-03-19 12:01:07
139	10133	0	2023-03-19 12:01:07
140	10121	0	2023-03-19 12:01:07
141	10126	0	2023-03-19 12:01:08
142	10125	0	2023-03-19 12:01:08
143	10124	0	2023-03-19 12:01:09
144	10135	0	2023-03-19 12:01:09
145	10123	0	2023-03-19 12:01:09
146	10084	12936790016	2023-03-19 12:01:10
147	10155	0	2023-03-19 12:01:10
148	10129	0	2023-03-19 12:01:10
149	10122	0	2023-03-19 12:01:10
150	10136	0	2023-03-19 12:01:11
151	10119	0	2023-03-19 12:01:11
152	10128	0	2023-03-19 12:01:11
153	10151	0	2023-03-19 12:01:12
154	10127	0	2023-03-19 12:01:12
\.


--
-- TOC entry 3215 (class 0 OID 141204)
-- Dependencies: 224
-- Data for Name: size_total; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.size_total (id_size_total, hostid, value_size_total, time_size_total) FROM stdin;
133	10132	0	2023-03-19 12:01:12
134	10130	0	2023-03-19 12:01:13
135	10120	0	2023-03-19 12:01:13
136	10152	0	2023-03-19 12:01:14
137	10131	0	2023-03-19 12:01:14
138	10134	0	2023-03-19 12:01:14
139	10133	0	2023-03-19 12:01:14
140	10121	0	2023-03-19 12:01:15
141	10126	0	2023-03-19 12:01:15
142	10125	0	2023-03-19 12:01:16
143	10124	0	2023-03-19 12:01:16
144	10135	0	2023-03-19 12:01:16
145	10123	0	2023-03-19 12:01:17
146	10084	20091629568	2023-03-19 12:01:17
147	10155	0	2023-03-19 12:01:17
148	10129	0	2023-03-19 12:01:17
149	10122	0	2023-03-19 12:01:18
150	10136	0	2023-03-19 12:01:18
151	10119	0	2023-03-19 12:01:18
152	10128	0	2023-03-19 12:01:19
153	10151	0	2023-03-19 12:01:19
154	10127	0	2023-03-19 12:01:19
\.


--
-- TOC entry 3246 (class 0 OID 0)
-- Dependencies: 234
-- Name: User_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_id_user_seq"', 1, true);


--
-- TOC entry 3247 (class 0 OID 0)
-- Dependencies: 201
-- Name: cpu_interrupt_id_cpu_interrupt_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_interrupt_id_cpu_interrupt_seq', 280, true);


--
-- TOC entry 3248 (class 0 OID 0)
-- Dependencies: 203
-- Name: cpu_lowait_id_cpu_lowait_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_lowait_id_cpu_lowait_seq', 280, true);


--
-- TOC entry 3249 (class 0 OID 0)
-- Dependencies: 205
-- Name: cpu_nice_id_cpu_nice_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_nice_id_cpu_nice_seq', 280, true);


--
-- TOC entry 3250 (class 0 OID 0)
-- Dependencies: 207
-- Name: cpu_softirq_id_cpu_softirq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_softirq_id_cpu_softirq_seq', 280, true);


--
-- TOC entry 3251 (class 0 OID 0)
-- Dependencies: 209
-- Name: cpu_steal_id_cpu_steal_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_steal_id_cpu_steal_seq', 280, true);


--
-- TOC entry 3252 (class 0 OID 0)
-- Dependencies: 211
-- Name: cpu_system_id_cpu_system_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_system_id_cpu_system_seq', 280, true);


--
-- TOC entry 3253 (class 0 OID 0)
-- Dependencies: 213
-- Name: cpu_util_idle_id_cpu_util_idle_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_util_idle_id_cpu_util_idle_seq', 396, true);


--
-- TOC entry 3254 (class 0 OID 0)
-- Dependencies: 215
-- Name: cpu_util_user_id_cpu_util_user_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_util_user_id_cpu_util_user_seq', 396, true);


--
-- TOC entry 3255 (class 0 OID 0)
-- Dependencies: 227
-- Name: memory_available_id_memory_available_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.memory_available_id_memory_available_seq', 391, true);


--
-- TOC entry 3256 (class 0 OID 0)
-- Dependencies: 228
-- Name: memory_total_id_memory_total_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.memory_total_id_memory_total_seq', 391, true);


--
-- TOC entry 3257 (class 0 OID 0)
-- Dependencies: 229
-- Name: percpu_avg15_id_percpu_avg15_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.percpu_avg15_id_percpu_avg15_seq', 436, true);


--
-- TOC entry 3258 (class 0 OID 0)
-- Dependencies: 230
-- Name: percpu_avg1_id_percpu_avg1_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.percpu_avg1_id_percpu_avg1_seq', 396, true);


--
-- TOC entry 3259 (class 0 OID 0)
-- Dependencies: 231
-- Name: percpu_avg5_id_percpu_avg5_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.percpu_avg5_id_percpu_avg5_seq', 396, true);


--
-- TOC entry 3260 (class 0 OID 0)
-- Dependencies: 232
-- Name: size_free_id_size_free_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.size_free_id_size_free_seq', 154, true);


--
-- TOC entry 3261 (class 0 OID 0)
-- Dependencies: 233
-- Name: size_total_id_size_total_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.size_total_id_size_total_seq', 154, true);


--
-- TOC entry 3024 (class 2606 OID 141248)
-- Name: history history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_pkey PRIMARY KEY (id_history);


--
-- TOC entry 3042 (class 2606 OID 148762)
-- Name: User pk_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT pk_1 PRIMARY KEY (id_user);


--
-- TOC entry 3008 (class 2606 OID 141250)
-- Name: cpu_interrupt pk_cpu_interrupt; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_interrupt
    ADD CONSTRAINT pk_cpu_interrupt PRIMARY KEY (id_cpu_interrupt);


--
-- TOC entry 3010 (class 2606 OID 141252)
-- Name: cpu_Iowait pk_cpu_lowait; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."cpu_Iowait"
    ADD CONSTRAINT pk_cpu_lowait PRIMARY KEY ("id_cpu_Iowait");


--
-- TOC entry 3012 (class 2606 OID 141254)
-- Name: cpu_nice pk_cpu_nice; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_nice
    ADD CONSTRAINT pk_cpu_nice PRIMARY KEY (id_cpu_nice);


--
-- TOC entry 3014 (class 2606 OID 141256)
-- Name: cpu_softirq pk_cpu_softirq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_softirq
    ADD CONSTRAINT pk_cpu_softirq PRIMARY KEY (id_cpu_softirq);


--
-- TOC entry 3016 (class 2606 OID 141258)
-- Name: cpu_steal pk_cpu_steal; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_steal
    ADD CONSTRAINT pk_cpu_steal PRIMARY KEY (id_cpu_steal);


--
-- TOC entry 3018 (class 2606 OID 141260)
-- Name: cpu_system pk_cpu_system; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_system
    ADD CONSTRAINT pk_cpu_system PRIMARY KEY (id_cpu_system);


--
-- TOC entry 3020 (class 2606 OID 141262)
-- Name: cpu_util_idle pk_cpu_util_idle; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_util_idle
    ADD CONSTRAINT pk_cpu_util_idle PRIMARY KEY (id_cpu_util_idle);


--
-- TOC entry 3022 (class 2606 OID 141264)
-- Name: cpu_util_user pk_cpu_util_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_util_user
    ADD CONSTRAINT pk_cpu_util_user PRIMARY KEY (id_cpu_util_user);


--
-- TOC entry 3026 (class 2606 OID 141266)
-- Name: host pk_host; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.host
    ADD CONSTRAINT pk_host PRIMARY KEY (hostid);


--
-- TOC entry 3028 (class 2606 OID 141268)
-- Name: memory_available pk_memory_available; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_available
    ADD CONSTRAINT pk_memory_available PRIMARY KEY (id_memory_available);


--
-- TOC entry 3030 (class 2606 OID 141270)
-- Name: memory_total pk_memory_total; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_total
    ADD CONSTRAINT pk_memory_total PRIMARY KEY (id_memory_total);


--
-- TOC entry 3032 (class 2606 OID 141272)
-- Name: percpu_avg1 pk_percpu_avg1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg1
    ADD CONSTRAINT pk_percpu_avg1 PRIMARY KEY (id_percpu_avg1);


--
-- TOC entry 3034 (class 2606 OID 141274)
-- Name: percpu_avg15 pk_percpu_avg15; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg15
    ADD CONSTRAINT pk_percpu_avg15 PRIMARY KEY (id_percpu_avg15);


--
-- TOC entry 3036 (class 2606 OID 141276)
-- Name: percpu_avg5 pk_percpu_avg5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg5
    ADD CONSTRAINT pk_percpu_avg5 PRIMARY KEY (id_percpu_avg5);


--
-- TOC entry 3038 (class 2606 OID 141278)
-- Name: size_free pk_size_free; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_free
    ADD CONSTRAINT pk_size_free PRIMARY KEY (id_size_free);


--
-- TOC entry 3040 (class 2606 OID 141280)
-- Name: size_total pk_size_total; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_total
    ADD CONSTRAINT pk_size_total PRIMARY KEY (id_size_total);


--
-- TOC entry 3043 (class 2606 OID 141281)
-- Name: cpu_interrupt cpu_interrupt_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_interrupt
    ADD CONSTRAINT cpu_interrupt_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3044 (class 2606 OID 141286)
-- Name: cpu_Iowait cpu_lowait_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."cpu_Iowait"
    ADD CONSTRAINT cpu_lowait_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3045 (class 2606 OID 141291)
-- Name: cpu_nice cpu_nice_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_nice
    ADD CONSTRAINT cpu_nice_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3046 (class 2606 OID 141296)
-- Name: cpu_softirq cpu_softirq_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_softirq
    ADD CONSTRAINT cpu_softirq_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3047 (class 2606 OID 141301)
-- Name: cpu_steal cpu_steal_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_steal
    ADD CONSTRAINT cpu_steal_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3048 (class 2606 OID 141306)
-- Name: cpu_system cpu_system_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_system
    ADD CONSTRAINT cpu_system_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3049 (class 2606 OID 141311)
-- Name: cpu_util_idle cpu_util_idle_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_util_idle
    ADD CONSTRAINT cpu_util_idle_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3050 (class 2606 OID 141316)
-- Name: cpu_util_user cpu_util_user_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_util_user
    ADD CONSTRAINT cpu_util_user_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3051 (class 2606 OID 141321)
-- Name: history history_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.history
    ADD CONSTRAINT history_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3052 (class 2606 OID 141326)
-- Name: memory_available memory_available_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_available
    ADD CONSTRAINT memory_available_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3053 (class 2606 OID 141331)
-- Name: memory_total memory_total_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_total
    ADD CONSTRAINT memory_total_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3055 (class 2606 OID 141336)
-- Name: percpu_avg15 percpu_avg15_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg15
    ADD CONSTRAINT percpu_avg15_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3054 (class 2606 OID 141341)
-- Name: percpu_avg1 percpu_avg1_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg1
    ADD CONSTRAINT percpu_avg1_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3056 (class 2606 OID 141346)
-- Name: percpu_avg5 percpu_avg5_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg5
    ADD CONSTRAINT percpu_avg5_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3057 (class 2606 OID 141351)
-- Name: size_free size_free_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_free
    ADD CONSTRAINT size_free_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3058 (class 2606 OID 141356)
-- Name: size_total size_total_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_total
    ADD CONSTRAINT size_total_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


-- Completed on 2023-03-25 12:47:07

--
-- PostgreSQL database dump complete
--

