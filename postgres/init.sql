--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.4

-- Started on 2023-04-10 20:23:01

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
-- TOC entry 236 (class 1255 OID 165137)
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
-- TOC entry 237 (class 1255 OID 165138)
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
-- TOC entry 238 (class 1255 OID 165139)
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
-- TOC entry 234 (class 1259 OID 165413)
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
-- TOC entry 233 (class 1259 OID 165411)
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
-- TOC entry 3233 (class 0 OID 0)
-- Dependencies: 233
-- Name: User_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."User_id_user_seq" OWNED BY public."User".id_user;


--
-- TOC entry 200 (class 1259 OID 165140)
-- Name: cpu_Iowait; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."cpu_Iowait" (
    "id_cpu_Iowait" integer NOT NULL,
    hostid integer NOT NULL,
    "value_cpu_Iowait" double precision DEFAULT 0.0 NOT NULL,
    "time_cpu_Iowait" timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_lowait CHECK ((("value_cpu_Iowait" >= (0)::double precision) AND ("value_cpu_Iowait" <= (100)::double precision)))
);


ALTER TABLE public."cpu_Iowait" OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 165145)
-- Name: cpu_interrupt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_interrupt (
    id_cpu_interrupt integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_interrupt double precision DEFAULT 0.0 NOT NULL,
    time_cpu_interrupt timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_interrupt CHECK (((value_cpu_interrupt >= (0)::double precision) AND (value_cpu_interrupt <= (100)::double precision)))
);


ALTER TABLE public.cpu_interrupt OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 165150)
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
-- TOC entry 3234 (class 0 OID 0)
-- Dependencies: 202
-- Name: cpu_interrupt_id_cpu_interrupt_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_interrupt_id_cpu_interrupt_seq OWNED BY public.cpu_interrupt.id_cpu_interrupt;


--
-- TOC entry 203 (class 1259 OID 165152)
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
-- TOC entry 3235 (class 0 OID 0)
-- Dependencies: 203
-- Name: cpu_lowait_id_cpu_lowait_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_lowait_id_cpu_lowait_seq OWNED BY public."cpu_Iowait"."id_cpu_Iowait";


--
-- TOC entry 204 (class 1259 OID 165154)
-- Name: cpu_nice; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_nice (
    id_cpu_nice integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_nice double precision DEFAULT 0.0 NOT NULL,
    time_cpu_nice timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_nice CHECK (((value_cpu_nice >= (0)::double precision) AND (value_cpu_nice <= (100)::double precision)))
);


ALTER TABLE public.cpu_nice OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 165159)
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
-- TOC entry 3236 (class 0 OID 0)
-- Dependencies: 205
-- Name: cpu_nice_id_cpu_nice_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_nice_id_cpu_nice_seq OWNED BY public.cpu_nice.id_cpu_nice;


--
-- TOC entry 206 (class 1259 OID 165161)
-- Name: cpu_softirq; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_softirq (
    id_cpu_softirq integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_softirq double precision DEFAULT 0.0 NOT NULL,
    time_cpu_softirq timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_softirq CHECK (((value_cpu_softirq >= (0)::double precision) AND (value_cpu_softirq <= (100)::double precision)))
);


ALTER TABLE public.cpu_softirq OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 165166)
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
-- TOC entry 3237 (class 0 OID 0)
-- Dependencies: 207
-- Name: cpu_softirq_id_cpu_softirq_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_softirq_id_cpu_softirq_seq OWNED BY public.cpu_softirq.id_cpu_softirq;


--
-- TOC entry 208 (class 1259 OID 165168)
-- Name: cpu_steal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_steal (
    id_cpu_steal integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_steal double precision DEFAULT 0.0 NOT NULL,
    time_cpu_steal timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_steal CHECK (((value_cpu_steal >= (0)::double precision) AND (value_cpu_steal <= (100)::double precision)))
);


ALTER TABLE public.cpu_steal OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 165173)
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
-- TOC entry 3238 (class 0 OID 0)
-- Dependencies: 209
-- Name: cpu_steal_id_cpu_steal_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_steal_id_cpu_steal_seq OWNED BY public.cpu_steal.id_cpu_steal;


--
-- TOC entry 210 (class 1259 OID 165175)
-- Name: cpu_system; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_system (
    id_cpu_system integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_system double precision DEFAULT 0.0 NOT NULL,
    time_cpu_system timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_system CHECK (((value_cpu_system >= (0)::double precision) AND (value_cpu_system <= (100)::double precision)))
);


ALTER TABLE public.cpu_system OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 165180)
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
-- TOC entry 3239 (class 0 OID 0)
-- Dependencies: 211
-- Name: cpu_system_id_cpu_system_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_system_id_cpu_system_seq OWNED BY public.cpu_system.id_cpu_system;


--
-- TOC entry 212 (class 1259 OID 165182)
-- Name: cpu_util_idle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cpu_util_idle (
    id_cpu_util_idle integer NOT NULL,
    hostid integer NOT NULL,
    value_cpu_util_idle double precision DEFAULT 0.0 NOT NULL,
    time_cpu_util_idle timestamp without time zone NOT NULL,
    CONSTRAINT ch_value_cpu_util_idle CHECK (((value_cpu_util_idle >= (0)::double precision) AND (value_cpu_util_idle <= (100)::double precision)))
);


ALTER TABLE public.cpu_util_idle OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 165187)
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
-- TOC entry 3240 (class 0 OID 0)
-- Dependencies: 213
-- Name: cpu_util_idle_id_cpu_util_idle_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_util_idle_id_cpu_util_idle_seq OWNED BY public.cpu_util_idle.id_cpu_util_idle;


--
-- TOC entry 214 (class 1259 OID 165189)
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
-- TOC entry 215 (class 1259 OID 165194)
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
-- TOC entry 3241 (class 0 OID 0)
-- Dependencies: 215
-- Name: cpu_util_user_id_cpu_util_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cpu_util_user_id_cpu_util_user_seq OWNED BY public.cpu_util_user.id_cpu_util_user;


--
-- TOC entry 216 (class 1259 OID 165196)
-- Name: host; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.host (
    hostid integer NOT NULL,
    name_host character varying,
    ip_host text[]
);


ALTER TABLE public.host OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 165202)
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
-- TOC entry 218 (class 1259 OID 165207)
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
-- TOC entry 219 (class 1259 OID 165212)
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
-- TOC entry 220 (class 1259 OID 165217)
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
-- TOC entry 221 (class 1259 OID 165222)
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
-- TOC entry 222 (class 1259 OID 165227)
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
-- TOC entry 223 (class 1259 OID 165232)
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
-- TOC entry 235 (class 1259 OID 173328)
-- Name: host_info; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.host_info AS
 SELECT host.hostid,
    host.name_host,
    host.ip_host,
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
    cpu_util_idle.time_cpu_util_idle,
    cpu_util_user.value_cpu_util_user,
    cpu_util_user.time_cpu_util_user,
    cpu_system.value_cpu_system,
    cpu_system.time_cpu_system,
    cpu_steal.value_cpu_steal,
    cpu_steal.time_cpu_steal,
    cpu_softirq.value_cpu_softirq,
    cpu_softirq.time_cpu_softirq,
    cpu_nice.value_cpu_nice,
    cpu_nice.time_cpu_nice,
    cpu_interrupt.value_cpu_interrupt,
    cpu_interrupt.time_cpu_interrupt,
    "cpu_Iowait"."value_cpu_Iowait",
    "cpu_Iowait"."time_cpu_Iowait"
   FROM (((((((((((((((public.host
     FULL JOIN public.percpu_avg1 ON ((host.hostid = percpu_avg1.hostid)))
     FULL JOIN public.percpu_avg5 ON ((host.hostid = percpu_avg5.hostid)))
     FULL JOIN public.percpu_avg15 ON ((host.hostid = percpu_avg15.hostid)))
     FULL JOIN public.size_free ON ((host.hostid = size_free.hostid)))
     FULL JOIN public.size_total ON ((host.hostid = size_total.hostid)))
     FULL JOIN public.memory_available ON ((host.hostid = memory_available.hostid)))
     FULL JOIN public.memory_total ON ((host.hostid = memory_total.hostid)))
     FULL JOIN public.cpu_util_idle ON ((host.hostid = cpu_util_idle.hostid)))
     FULL JOIN public.cpu_util_user ON ((host.hostid = cpu_util_user.hostid)))
     FULL JOIN public.cpu_system ON ((host.hostid = cpu_system.hostid)))
     FULL JOIN public.cpu_steal ON ((host.hostid = cpu_steal.hostid)))
     FULL JOIN public.cpu_softirq ON ((host.hostid = cpu_softirq.hostid)))
     FULL JOIN public.cpu_nice ON ((host.hostid = cpu_nice.hostid)))
     FULL JOIN public.cpu_interrupt ON ((host.hostid = cpu_interrupt.hostid)))
     FULL JOIN public."cpu_Iowait" ON ((host.hostid = "cpu_Iowait".hostid)));


ALTER TABLE public.host_info OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 165242)
-- Name: triggers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.triggers (
    triggerid integer NOT NULL,
    triggers_expression character varying,
    description character varying,
    priority character varying,
    hostid integer NOT NULL
);


ALTER TABLE public.triggers OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 165248)
-- Name: host_work; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.host_work AS
 SELECT host.hostid,
    host.name_host,
    host.ip_host,
    triggers.priority,
    triggers.description
   FROM (public.host
     FULL JOIN public.triggers ON ((host.hostid = triggers.hostid)));


ALTER TABLE public.host_work OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 165252)
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
-- TOC entry 3242 (class 0 OID 0)
-- Dependencies: 226
-- Name: memory_available_id_memory_available_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.memory_available_id_memory_available_seq OWNED BY public.memory_available.id_memory_available;


--
-- TOC entry 227 (class 1259 OID 165254)
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
-- TOC entry 3243 (class 0 OID 0)
-- Dependencies: 227
-- Name: memory_total_id_memory_total_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.memory_total_id_memory_total_seq OWNED BY public.memory_total.id_memory_total;


--
-- TOC entry 228 (class 1259 OID 165256)
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
-- TOC entry 3244 (class 0 OID 0)
-- Dependencies: 228
-- Name: percpu_avg15_id_percpu_avg15_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.percpu_avg15_id_percpu_avg15_seq OWNED BY public.percpu_avg15.id_percpu_avg15;


--
-- TOC entry 229 (class 1259 OID 165258)
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
-- TOC entry 3245 (class 0 OID 0)
-- Dependencies: 229
-- Name: percpu_avg1_id_percpu_avg1_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.percpu_avg1_id_percpu_avg1_seq OWNED BY public.percpu_avg1.id_percpu_avg1;


--
-- TOC entry 230 (class 1259 OID 165260)
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
-- TOC entry 3246 (class 0 OID 0)
-- Dependencies: 230
-- Name: percpu_avg5_id_percpu_avg5_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.percpu_avg5_id_percpu_avg5_seq OWNED BY public.percpu_avg5.id_percpu_avg5;


--
-- TOC entry 231 (class 1259 OID 165262)
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
-- TOC entry 3247 (class 0 OID 0)
-- Dependencies: 231
-- Name: size_free_id_size_free_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.size_free_id_size_free_seq OWNED BY public.size_free.id_size_free;


--
-- TOC entry 232 (class 1259 OID 165264)
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
-- TOC entry 3248 (class 0 OID 0)
-- Dependencies: 232
-- Name: size_total_id_size_total_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.size_total_id_size_total_seq OWNED BY public.size_total.id_size_total;


--
-- TOC entry 3007 (class 2604 OID 165416)
-- Name: User id_user; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User" ALTER COLUMN id_user SET DEFAULT nextval('public."User_id_user_seq"'::regclass);


--
-- TOC entry 2963 (class 2604 OID 165396)
-- Name: cpu_Iowait id_cpu_Iowait; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."cpu_Iowait" ALTER COLUMN "id_cpu_Iowait" SET DEFAULT nextval('public.cpu_lowait_id_cpu_lowait_seq'::regclass);


--
-- TOC entry 2966 (class 2604 OID 165397)
-- Name: cpu_interrupt id_cpu_interrupt; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_interrupt ALTER COLUMN id_cpu_interrupt SET DEFAULT nextval('public.cpu_interrupt_id_cpu_interrupt_seq'::regclass);


--
-- TOC entry 2969 (class 2604 OID 165398)
-- Name: cpu_nice id_cpu_nice; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_nice ALTER COLUMN id_cpu_nice SET DEFAULT nextval('public.cpu_nice_id_cpu_nice_seq'::regclass);


--
-- TOC entry 2972 (class 2604 OID 165399)
-- Name: cpu_softirq id_cpu_softirq; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_softirq ALTER COLUMN id_cpu_softirq SET DEFAULT nextval('public.cpu_softirq_id_cpu_softirq_seq'::regclass);


--
-- TOC entry 2975 (class 2604 OID 165400)
-- Name: cpu_steal id_cpu_steal; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_steal ALTER COLUMN id_cpu_steal SET DEFAULT nextval('public.cpu_steal_id_cpu_steal_seq'::regclass);


--
-- TOC entry 2978 (class 2604 OID 165401)
-- Name: cpu_system id_cpu_system; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_system ALTER COLUMN id_cpu_system SET DEFAULT nextval('public.cpu_system_id_cpu_system_seq'::regclass);


--
-- TOC entry 2981 (class 2604 OID 165402)
-- Name: cpu_util_idle id_cpu_util_idle; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_util_idle ALTER COLUMN id_cpu_util_idle SET DEFAULT nextval('public.cpu_util_idle_id_cpu_util_idle_seq'::regclass);


--
-- TOC entry 2984 (class 2604 OID 165403)
-- Name: cpu_util_user id_cpu_util_user; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_util_user ALTER COLUMN id_cpu_util_user SET DEFAULT nextval('public.cpu_util_user_id_cpu_util_user_seq'::regclass);


--
-- TOC entry 2987 (class 2604 OID 165404)
-- Name: memory_available id_memory_available; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_available ALTER COLUMN id_memory_available SET DEFAULT nextval('public.memory_available_id_memory_available_seq'::regclass);


--
-- TOC entry 2990 (class 2604 OID 165405)
-- Name: memory_total id_memory_total; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_total ALTER COLUMN id_memory_total SET DEFAULT nextval('public.memory_total_id_memory_total_seq'::regclass);


--
-- TOC entry 2993 (class 2604 OID 165406)
-- Name: percpu_avg1 id_percpu_avg1; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg1 ALTER COLUMN id_percpu_avg1 SET DEFAULT nextval('public.percpu_avg1_id_percpu_avg1_seq'::regclass);


--
-- TOC entry 2996 (class 2604 OID 165407)
-- Name: percpu_avg15 id_percpu_avg15; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg15 ALTER COLUMN id_percpu_avg15 SET DEFAULT nextval('public.percpu_avg15_id_percpu_avg15_seq'::regclass);


--
-- TOC entry 2999 (class 2604 OID 165408)
-- Name: percpu_avg5 id_percpu_avg5; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg5 ALTER COLUMN id_percpu_avg5 SET DEFAULT nextval('public.percpu_avg5_id_percpu_avg5_seq'::regclass);


--
-- TOC entry 3002 (class 2604 OID 165409)
-- Name: size_free id_size_free; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_free ALTER COLUMN id_size_free SET DEFAULT nextval('public.size_free_id_size_free_seq'::regclass);


--
-- TOC entry 3005 (class 2604 OID 165410)
-- Name: size_total id_size_total; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_total ALTER COLUMN id_size_total SET DEFAULT nextval('public.size_total_id_size_total_seq'::regclass);


--
-- TOC entry 3227 (class 0 OID 165413)
-- Dependencies: 234
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."User" (id_user, surname, name, patronymic, login, password) FROM stdin;
1	TestSurname1	TestName1	TestPatronymic1	login	6875723739323868726f69666e77727669646f687563696779373833393866716568636477696e6f5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8
2	TestSurname1	TestName1	TestPatronymic1	login2	6875723739323868726f69666e77727669646f687563696779373833393866716568636477696e6f5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8
9	Доброславский	Сергей	Владимирович	Ser123	6875723739323868726f69666e77727669646f687563696779373833393866716568636477696e6fb1b3773a05c0ed0176787a4f1574ff0075f7521e
\.


--
-- TOC entry 3194 (class 0 OID 165140)
-- Dependencies: 200
-- Data for Name: cpu_Iowait; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."cpu_Iowait" ("id_cpu_Iowait", hostid, "value_cpu_Iowait", "time_cpu_Iowait") FROM stdin;
9812	10119	0	2023-04-04 15:05:39
9813	10120	0.0165	2023-04-04 15:05:39
9814	10121	0	2023-04-04 15:05:39
9815	10122	0	2023-04-04 15:05:39
9816	10125	0	2023-04-04 15:05:39
9817	10127	0	2023-04-04 15:05:39
9818	10126	0	2023-04-04 15:05:39
9819	10123	0	2023-04-04 15:05:39
9820	10084	0.068	2023-04-04 15:05:39
9821	10124	0	2023-04-04 15:05:39
9822	10128	0	2023-04-04 15:05:39
9823	10129	0	2023-04-04 15:05:39
9824	10130	0	2023-04-04 15:05:39
9825	10131	0	2023-04-04 15:05:39
9826	10132	0	2023-04-04 15:05:39
9827	10133	0	2023-04-04 15:05:39
9828	10134	0	2023-04-04 15:05:39
9829	10135	0	2023-04-04 15:05:39
9830	10136	0	2023-04-04 15:05:39
9831	10137	0	2023-04-04 15:05:39
9832	10138	0	2023-04-04 15:05:39
9833	10139	0	2023-04-04 15:05:39
9834	10140	0	2023-04-04 15:05:39
9835	10141	0	2023-04-04 15:05:39
9836	10142	0	2023-04-04 15:05:39
9837	10143	0	2023-04-04 15:05:39
9838	10144	0	2023-04-04 15:05:39
9839	10145	0	2023-04-04 15:05:39
9840	10146	0	2023-04-04 15:05:39
9841	10147	0	2023-04-04 15:05:39
9842	10148	0	2023-04-04 15:05:39
9843	10149	0	2023-04-04 15:05:39
9844	10150	0	2023-04-04 15:05:39
9845	10151	0	2023-04-04 15:05:39
9846	10152	0	2023-04-04 15:05:39
9847	10153	0	2023-04-04 15:05:39
9848	10156	0	2023-04-04 15:05:39
9849	10154	0	2023-04-04 15:05:39
9850	10157	0	2023-04-04 15:05:39
9851	10155	0	2023-04-04 15:05:39
\.


--
-- TOC entry 3195 (class 0 OID 165145)
-- Dependencies: 201
-- Data for Name: cpu_interrupt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_interrupt (id_cpu_interrupt, hostid, value_cpu_interrupt, time_cpu_interrupt) FROM stdin;
9812	10119	0	2023-04-04 15:05:39
9813	10120	0	2023-04-04 15:05:39
9814	10121	0	2023-04-04 15:05:39
9815	10122	0	2023-04-04 15:05:39
9816	10125	0	2023-04-04 15:05:39
9817	10126	0	2023-04-04 15:05:39
9818	10127	0	2023-04-04 15:05:39
9819	10123	0	2023-04-04 15:05:39
9820	10084	0	2023-04-04 15:05:39
9821	10124	0	2023-04-04 15:05:39
9822	10128	0	2023-04-04 15:05:39
9823	10129	0	2023-04-04 15:05:39
9824	10130	0	2023-04-04 15:05:39
9825	10131	0	2023-04-04 15:05:39
9826	10132	0	2023-04-04 15:05:39
9827	10133	0	2023-04-04 15:05:39
9828	10134	0	2023-04-04 15:05:39
9829	10135	0	2023-04-04 15:05:39
9830	10136	0	2023-04-04 15:05:39
9831	10137	0	2023-04-04 15:05:39
9832	10138	0	2023-04-04 15:05:39
9833	10139	0	2023-04-04 15:05:39
9834	10140	0	2023-04-04 15:05:39
9835	10141	0	2023-04-04 15:05:39
9836	10142	0	2023-04-04 15:05:39
9837	10143	0	2023-04-04 15:05:39
9838	10144	0	2023-04-04 15:05:39
9839	10145	0	2023-04-04 15:05:39
9840	10146	0	2023-04-04 15:05:39
9841	10147	0	2023-04-04 15:05:39
9842	10148	0	2023-04-04 15:05:39
9843	10149	0	2023-04-04 15:05:39
9844	10150	0	2023-04-04 15:05:39
9845	10151	0	2023-04-04 15:05:39
9846	10152	0	2023-04-04 15:05:39
9847	10153	0	2023-04-04 15:05:39
9848	10156	0	2023-04-04 15:05:39
9849	10154	0	2023-04-04 15:05:39
9850	10157	0	2023-04-04 15:05:39
9851	10155	0	2023-04-04 15:05:39
\.


--
-- TOC entry 3198 (class 0 OID 165154)
-- Dependencies: 204
-- Data for Name: cpu_nice; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_nice (id_cpu_nice, hostid, value_cpu_nice, time_cpu_nice) FROM stdin;
9812	10119	0	2023-04-04 15:05:39
9813	10120	0	2023-04-04 15:05:39
9814	10121	0	2023-04-04 15:05:39
9815	10125	0	2023-04-04 15:05:39
9816	10122	0	2023-04-04 15:05:39
9817	10127	0	2023-04-04 15:05:39
9818	10126	0	2023-04-04 15:05:39
9819	10123	0	2023-04-04 15:05:39
9820	10084	0	2023-04-04 15:05:39
9821	10124	0	2023-04-04 15:05:39
9822	10128	0	2023-04-04 15:05:39
9823	10129	0	2023-04-04 15:05:39
9824	10130	0	2023-04-04 15:05:39
9825	10131	0	2023-04-04 15:05:39
9826	10132	0	2023-04-04 15:05:39
9827	10133	0	2023-04-04 15:05:39
9828	10134	0	2023-04-04 15:05:39
9829	10135	0	2023-04-04 15:05:39
9830	10136	0	2023-04-04 15:05:39
9831	10137	0	2023-04-04 15:05:39
9832	10138	0	2023-04-04 15:05:39
9833	10139	0	2023-04-04 15:05:39
9834	10140	0	2023-04-04 15:05:39
9835	10141	0	2023-04-04 15:05:39
9836	10142	0	2023-04-04 15:05:39
9837	10143	0	2023-04-04 15:05:39
9838	10144	0	2023-04-04 15:05:39
9839	10145	0	2023-04-04 15:05:39
9840	10146	0	2023-04-04 15:05:39
9841	10147	0	2023-04-04 15:05:39
9842	10148	0	2023-04-04 15:05:39
9843	10149	0	2023-04-04 15:05:39
9844	10150	0	2023-04-04 15:05:39
9845	10151	0	2023-04-04 15:05:39
9846	10152	0	2023-04-04 15:05:39
9847	10153	0	2023-04-04 15:05:39
9848	10156	0	2023-04-04 15:05:39
9849	10154	0	2023-04-04 15:05:39
9850	10157	0	2023-04-04 15:05:39
9851	10155	0	2023-04-04 15:05:39
\.


--
-- TOC entry 3200 (class 0 OID 165161)
-- Dependencies: 206
-- Data for Name: cpu_softirq; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_softirq (id_cpu_softirq, hostid, value_cpu_softirq, time_cpu_softirq) FROM stdin;
9812	10119	0	2023-04-04 15:05:40
9813	10120	0.0165	2023-04-04 15:05:40
9814	10121	0	2023-04-04 15:05:40
9815	10122	0	2023-04-04 15:05:40
9816	10125	0	2023-04-04 15:05:40
9817	10126	0	2023-04-04 15:05:40
9818	10127	0	2023-04-04 15:05:40
9819	10123	0	2023-04-04 15:05:40
9820	10084	0.068	2023-04-04 15:05:40
9821	10124	0	2023-04-04 15:05:40
9822	10128	0	2023-04-04 15:05:40
9823	10129	0	2023-04-04 15:05:40
9824	10130	0	2023-04-04 15:05:40
9825	10131	0	2023-04-04 15:05:40
9826	10132	0	2023-04-04 15:05:40
9827	10133	0	2023-04-04 15:05:40
9828	10134	0	2023-04-04 15:05:40
9829	10135	0	2023-04-04 15:05:40
9830	10136	0	2023-04-04 15:05:40
9831	10137	0	2023-04-04 15:05:40
9832	10138	0	2023-04-04 15:05:40
9833	10139	0	2023-04-04 15:05:40
9834	10140	0	2023-04-04 15:05:40
9835	10141	0	2023-04-04 15:05:40
9836	10142	0	2023-04-04 15:05:40
9837	10143	0	2023-04-04 15:05:40
9838	10144	0	2023-04-04 15:05:40
9839	10145	0	2023-04-04 15:05:40
9840	10146	0	2023-04-04 15:05:40
9841	10147	0	2023-04-04 15:05:40
9842	10148	0	2023-04-04 15:05:40
9843	10149	0	2023-04-04 15:05:40
9844	10150	0	2023-04-04 15:05:40
9845	10151	0	2023-04-04 15:05:40
9846	10152	0	2023-04-04 15:05:40
9847	10153	0	2023-04-04 15:05:40
9848	10156	0	2023-04-04 15:05:40
9849	10154	0	2023-04-04 15:05:40
9850	10157	0	2023-04-04 15:05:40
9851	10155	0	2023-04-04 15:05:40
\.


--
-- TOC entry 3202 (class 0 OID 165168)
-- Dependencies: 208
-- Data for Name: cpu_steal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_steal (id_cpu_steal, hostid, value_cpu_steal, time_cpu_steal) FROM stdin;
9812	10119	0	2023-04-04 15:05:40
9813	10120	0	2023-04-04 15:05:40
9814	10121	0	2023-04-04 15:05:40
9815	10122	0	2023-04-04 15:05:40
9816	10125	0	2023-04-04 15:05:40
9817	10126	0	2023-04-04 15:05:40
9818	10127	0	2023-04-04 15:05:40
9819	10123	0	2023-04-04 15:05:40
9820	10084	0	2023-04-04 15:05:40
9821	10124	0	2023-04-04 15:05:40
9822	10128	0	2023-04-04 15:05:40
9823	10129	0	2023-04-04 15:05:40
9824	10130	0	2023-04-04 15:05:40
9825	10131	0	2023-04-04 15:05:40
9826	10132	0	2023-04-04 15:05:40
9827	10133	0	2023-04-04 15:05:40
9828	10134	0	2023-04-04 15:05:40
9829	10135	0	2023-04-04 15:05:40
9830	10136	0	2023-04-04 15:05:40
9831	10137	0	2023-04-04 15:05:40
9832	10138	0	2023-04-04 15:05:40
9833	10139	0	2023-04-04 15:05:40
9834	10140	0	2023-04-04 15:05:40
9835	10141	0	2023-04-04 15:05:40
9836	10142	0	2023-04-04 15:05:40
9837	10143	0	2023-04-04 15:05:40
9838	10144	0	2023-04-04 15:05:40
9839	10145	0	2023-04-04 15:05:40
9840	10146	0	2023-04-04 15:05:40
9841	10147	0	2023-04-04 15:05:40
9842	10148	0	2023-04-04 15:05:40
9843	10149	0	2023-04-04 15:05:40
9844	10150	0	2023-04-04 15:05:40
9845	10151	0	2023-04-04 15:05:40
9846	10152	0	2023-04-04 15:05:40
9847	10153	0	2023-04-04 15:05:40
9848	10156	0	2023-04-04 15:05:40
9849	10154	0	2023-04-04 15:05:40
9850	10157	0	2023-04-04 15:05:40
9851	10155	0	2023-04-04 15:05:40
\.


--
-- TOC entry 3204 (class 0 OID 165175)
-- Dependencies: 210
-- Data for Name: cpu_system; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_system (id_cpu_system, hostid, value_cpu_system, time_cpu_system) FROM stdin;
9812	10119	0	2023-04-04 15:05:40
9813	10120	0.117	2023-04-04 15:05:40
9814	10121	0	2023-04-04 15:05:40
9815	10125	0	2023-04-04 15:05:40
9816	10122	0	2023-04-04 15:05:40
9817	10127	0	2023-04-04 15:05:40
9818	10126	0	2023-04-04 15:05:40
9819	10123	0	2023-04-04 15:05:40
9820	10084	1.859	2023-04-04 15:05:40
9821	10124	0	2023-04-04 15:05:40
9822	10128	0	2023-04-04 15:05:40
9823	10129	0	2023-04-04 15:05:40
9824	10130	0	2023-04-04 15:05:40
9825	10131	0	2023-04-04 15:05:40
9826	10132	0	2023-04-04 15:05:40
9827	10133	0	2023-04-04 15:05:40
9828	10134	0	2023-04-04 15:05:40
9829	10135	0	2023-04-04 15:05:40
9830	10136	0	2023-04-04 15:05:40
9831	10137	0	2023-04-04 15:05:40
9832	10138	0	2023-04-04 15:05:40
9833	10139	0	2023-04-04 15:05:40
9834	10140	0	2023-04-04 15:05:40
9835	10141	0	2023-04-04 15:05:40
9836	10142	0	2023-04-04 15:05:40
9837	10143	0	2023-04-04 15:05:40
9838	10144	0	2023-04-04 15:05:40
9839	10145	0	2023-04-04 15:05:40
9840	10146	0	2023-04-04 15:05:40
9841	10147	0	2023-04-04 15:05:40
9842	10148	0	2023-04-04 15:05:40
9843	10149	0	2023-04-04 15:05:40
9844	10150	0	2023-04-04 15:05:40
9845	10151	0	2023-04-04 15:05:40
9846	10152	0	2023-04-04 15:05:40
9847	10153	0	2023-04-04 15:05:40
9848	10156	0	2023-04-04 15:05:40
9849	10154	0	2023-04-04 15:05:40
9850	10157	0	2023-04-04 15:05:40
9851	10155	0	2023-04-04 15:05:40
\.


--
-- TOC entry 3206 (class 0 OID 165182)
-- Dependencies: 212
-- Data for Name: cpu_util_idle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_util_idle (id_cpu_util_idle, hostid, value_cpu_util_idle, time_cpu_util_idle) FROM stdin;
9814	10119	0	2023-04-04 15:05:39
9815	10127	0	2023-04-04 15:05:39
9816	10120	99.66550000000001	2023-04-04 15:05:39
9817	10121	0	2023-04-04 15:05:39
9818	10125	0	2023-04-04 15:05:39
9819	10122	0	2023-04-04 15:05:39
9820	10126	0	2023-04-04 15:05:39
9821	10123	0	2023-04-04 15:05:39
9822	10084	67.648	2023-04-04 15:05:39
9823	10124	0	2023-04-04 15:05:39
9824	10128	0	2023-04-04 15:05:39
9825	10129	0	2023-04-04 15:05:39
9826	10130	0	2023-04-04 15:05:39
9827	10131	0	2023-04-04 15:05:39
9828	10132	0	2023-04-04 15:05:39
9829	10133	0	2023-04-04 15:05:39
9830	10134	0	2023-04-04 15:05:39
9831	10135	0	2023-04-04 15:05:39
9832	10136	0	2023-04-04 15:05:39
9833	10137	0	2023-04-04 15:05:39
9834	10138	0	2023-04-04 15:05:39
9835	10139	0	2023-04-04 15:05:39
9836	10140	0	2023-04-04 15:05:39
9837	10141	0	2023-04-04 15:05:39
9838	10142	0	2023-04-04 15:05:39
9839	10143	0	2023-04-04 15:05:39
9840	10144	0	2023-04-04 15:05:39
9841	10145	0	2023-04-04 15:05:39
9842	10146	0	2023-04-04 15:05:39
9843	10147	0	2023-04-04 15:05:39
9844	10148	0	2023-04-04 15:05:39
9845	10149	0	2023-04-04 15:05:39
9846	10150	0	2023-04-04 15:05:39
9847	10151	0	2023-04-04 15:05:39
9848	10152	0	2023-04-04 15:05:39
9849	10153	0	2023-04-04 15:05:39
9850	10156	0	2023-04-04 15:05:39
9851	10154	0	2023-04-04 15:05:39
9852	10157	0	2023-04-04 15:05:39
9853	10155	0	2023-04-04 15:05:39
\.


--
-- TOC entry 3208 (class 0 OID 165189)
-- Dependencies: 214
-- Data for Name: cpu_util_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cpu_util_user (id_cpu_util_user, hostid, value_cpu_util_user, time_cpu_util_user) FROM stdin;
9854	10119	0	2023-04-04 15:05:38
9855	10127	0	2023-04-04 15:05:38
9856	10120	0.184	2023-04-04 15:05:38
9857	10121	0	2023-04-04 15:05:38
9858	10125	0	2023-04-04 15:05:38
9859	10122	0	2023-04-04 15:05:38
9860	10126	0	2023-04-04 15:05:38
9861	10123	0	2023-04-04 15:05:38
9862	10084	22.0405	2023-04-04 15:05:38
9863	10124	0	2023-04-04 15:05:38
9864	10128	0	2023-04-04 15:05:38
9865	10129	0	2023-04-04 15:05:38
9866	10130	0	2023-04-04 15:05:38
9867	10131	0	2023-04-04 15:05:38
9868	10132	0	2023-04-04 15:05:38
9869	10133	0	2023-04-04 15:05:38
9870	10134	0	2023-04-04 15:05:38
9871	10135	0	2023-04-04 15:05:38
9872	10136	0	2023-04-04 15:05:38
9873	10137	0	2023-04-04 15:05:38
9874	10138	0	2023-04-04 15:05:38
9875	10139	0	2023-04-04 15:05:38
9876	10140	0	2023-04-04 15:05:38
9877	10141	0	2023-04-04 15:05:38
9878	10142	0	2023-04-04 15:05:38
9879	10143	0	2023-04-04 15:05:38
9880	10144	0	2023-04-04 15:05:38
9881	10145	0	2023-04-04 15:05:38
9882	10146	0	2023-04-04 15:05:38
9883	10147	0	2023-04-04 15:05:38
9884	10148	0	2023-04-04 15:05:38
9885	10149	0	2023-04-04 15:05:38
9886	10150	0	2023-04-04 15:05:38
9887	10151	0	2023-04-04 15:05:38
9888	10152	0	2023-04-04 15:05:38
9889	10153	0	2023-04-04 15:05:38
9890	10156	0	2023-04-04 15:05:38
9891	10154	0	2023-04-04 15:05:38
9892	10157	0	2023-04-04 15:05:38
9893	10155	0	2023-04-04 15:05:38
\.


--
-- TOC entry 3210 (class 0 OID 165196)
-- Dependencies: 216
-- Data for Name: host; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.host (hostid, name_host, ip_host) FROM stdin;
10084	MC1	{192.168.42.200,127.0.0.1}
10119	ARM01	{192.168.42.201}
10120	ARM02	{192.168.42.2}
10121	ARM03	{192.168.42.203}
10122	ARM04	{192.168.42.204}
10123	ARM05	{192.168.42.205}
10124	ARM06	{192.168.42.206}
10125	ARM07	{192.168.42.207}
10126	ARM17	{192.168.42.246}
10127	ARM08	{192.168.42.208}
10128	ARM09	{192.168.42.209}
10129	ARM10	{192.168.42.210}
10130	ARM11	{192.168.42.211}
10131	ARM12	{192.168.42.212}
10132	ARM13	{192.168.42.213}
10133	ARM14	{192.168.42.214}
10134	ARM15	{192.168.42.215}
10135	ARM16	{192.168.42.245}
10136	ARM18	{192.168.42.247}
10137	ARM19	{192.168.42.219}
10138	ARM20	{192.168.42.220}
10139	ARM21	{192.168.42.221}
10140	ARM22	{192.168.42.222}
10141	ARM23	{192.168.42.223}
10142	ARM24	{192.168.42.224}
10143	ARM25	{192.168.42.225}
10144	ARM26	{192.168.42.226}
10145	ARM27	{192.168.42.242}
10146	ARM28	{192.168.42.243}
10147	ARM29	{192.168.42.244}
10148	ARM30	{192.168.42.230}
10149	ARM31	{192.168.42.231}
10150	ARM32	{192.168.42.232}
10151	MC2	{192.168.42.216}
10152	CC1	{192.168.42.217}
10153	MC3	{192.168.42.252}
10154	MC4	{192.168.42.243}
10155	CC2	{192.168.42.218}
10156	CC3	{192.168.42.248}
10157	CC4	{192.168.42.249}
\.


--
-- TOC entry 3211 (class 0 OID 165202)
-- Dependencies: 217
-- Data for Name: memory_available; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.memory_available (id_memory_available, hostid, value_memory_available, time_memory_available) FROM stdin;
9814	10119	0	2023-04-04 15:05:41
9815	10120	1848455168	2023-04-04 15:05:41
9816	10121	0	2023-04-04 15:05:41
9817	10084	1726537728	2023-04-04 15:05:41
9818	10122	0	2023-04-04 15:05:41
9819	10125	0	2023-04-04 15:05:41
9820	10126	0	2023-04-04 15:05:41
9821	10127	0	2023-04-04 15:05:41
9822	10123	0	2023-04-04 15:05:41
9823	10124	0	2023-04-04 15:05:41
9824	10128	0	2023-04-04 15:05:41
9825	10129	0	2023-04-04 15:05:41
9826	10130	0	2023-04-04 15:05:41
9827	10131	0	2023-04-04 15:05:41
9828	10132	0	2023-04-04 15:05:41
9829	10133	0	2023-04-04 15:05:41
9830	10134	0	2023-04-04 15:05:41
9831	10135	0	2023-04-04 15:05:41
9832	10136	0	2023-04-04 15:05:41
9833	10137	0	2023-04-04 15:05:41
9834	10138	0	2023-04-04 15:05:41
9835	10139	0	2023-04-04 15:05:41
9836	10140	0	2023-04-04 15:05:41
9837	10141	0	2023-04-04 15:05:41
9838	10142	0	2023-04-04 15:05:41
9839	10143	0	2023-04-04 15:05:41
9840	10144	0	2023-04-04 15:05:41
9841	10145	0	2023-04-04 15:05:41
9842	10146	0	2023-04-04 15:05:41
9843	10147	0	2023-04-04 15:05:41
9844	10148	0	2023-04-04 15:05:41
9845	10149	0	2023-04-04 15:05:41
9846	10150	0	2023-04-04 15:05:41
9847	10151	0	2023-04-04 15:05:41
9848	10152	0	2023-04-04 15:05:41
9849	10153	0	2023-04-04 15:05:41
9850	10156	0	2023-04-04 15:05:41
9851	10154	0	2023-04-04 15:05:41
9852	10157	0	2023-04-04 15:05:41
9853	10155	0	2023-04-04 15:05:41
\.


--
-- TOC entry 3212 (class 0 OID 165207)
-- Dependencies: 218
-- Data for Name: memory_total; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.memory_total (id_memory_total, hostid, value_memory_total, time_memory_total) FROM stdin;
9814	10119	0	2023-04-04 15:05:41
9815	10127	0	2023-04-04 15:05:41
9816	10120	2095120384	2023-04-04 15:05:41
9817	10121	0	2023-04-04 15:05:41
9818	10125	0	2023-04-04 15:05:41
9819	10122	0	2023-04-04 15:05:41
9820	10126	0	2023-04-04 15:05:41
9821	10123	0	2023-04-04 15:05:41
9822	10084	0	2023-04-04 15:05:41
9823	10124	0	2023-04-04 15:05:41
9824	10128	0	2023-04-04 15:05:41
9825	10129	0	2023-04-04 15:05:41
9826	10130	0	2023-04-04 15:05:41
9827	10131	0	2023-04-04 15:05:41
9828	10132	0	2023-04-04 15:05:41
9829	10133	0	2023-04-04 15:05:41
9830	10134	0	2023-04-04 15:05:41
9831	10135	0	2023-04-04 15:05:41
9832	10136	0	2023-04-04 15:05:41
9833	10137	0	2023-04-04 15:05:41
9834	10138	0	2023-04-04 15:05:41
9835	10139	0	2023-04-04 15:05:41
9836	10140	0	2023-04-04 15:05:41
9837	10141	0	2023-04-04 15:05:41
9838	10142	0	2023-04-04 15:05:41
9839	10143	0	2023-04-04 15:05:41
9840	10144	0	2023-04-04 15:05:41
9841	10145	0	2023-04-04 15:05:41
9842	10146	0	2023-04-04 15:05:41
9843	10147	0	2023-04-04 15:05:41
9844	10148	0	2023-04-04 15:05:41
9845	10149	0	2023-04-04 15:05:41
9846	10150	0	2023-04-04 15:05:41
9847	10151	0	2023-04-04 15:05:41
9848	10152	0	2023-04-04 15:05:41
9849	10153	0	2023-04-04 15:05:41
9850	10156	0	2023-04-04 15:05:41
9851	10154	0	2023-04-04 15:05:41
9852	10157	0	2023-04-04 15:05:41
9853	10155	0	2023-04-04 15:05:41
\.


--
-- TOC entry 3213 (class 0 OID 165212)
-- Dependencies: 219
-- Data for Name: percpu_avg1; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.percpu_avg1 (id_percpu_avg1, hostid, value_percpu_avg1, time_percpu_avg1) FROM stdin;
9860	10119	0	2023-04-04 15:05:38
9861	10120	0	2023-04-04 15:05:38
9862	10125	0	2023-04-04 15:05:38
9863	10121	0	2023-04-04 15:05:38
9864	10122	0	2023-04-04 15:05:38
9865	10126	0	2023-04-04 15:05:38
9866	10123	0	2023-04-04 15:05:38
9867	10084	0.51	2023-04-04 15:05:38
9868	10127	0	2023-04-04 15:05:38
9869	10124	0	2023-04-04 15:05:38
9870	10128	0	2023-04-04 15:05:38
9871	10129	0	2023-04-04 15:05:38
9872	10130	0	2023-04-04 15:05:38
9873	10131	0	2023-04-04 15:05:38
9874	10132	0	2023-04-04 15:05:38
9875	10133	0	2023-04-04 15:05:38
9876	10134	0	2023-04-04 15:05:38
9877	10135	0	2023-04-04 15:05:38
9878	10136	0	2023-04-04 15:05:38
9879	10137	0	2023-04-04 15:05:38
9880	10138	0	2023-04-04 15:05:38
9881	10139	0	2023-04-04 15:05:38
9882	10140	0	2023-04-04 15:05:38
9883	10141	0	2023-04-04 15:05:38
9884	10142	0	2023-04-04 15:05:38
9885	10143	0	2023-04-04 15:05:38
9886	10144	0	2023-04-04 15:05:38
9887	10145	0	2023-04-04 15:05:38
9888	10146	0	2023-04-04 15:05:38
9889	10147	0	2023-04-04 15:05:38
9890	10148	0	2023-04-04 15:05:38
9891	10149	0	2023-04-04 15:05:38
9892	10150	0	2023-04-04 15:05:38
9893	10151	0	2023-04-04 15:05:38
9894	10152	0	2023-04-04 15:05:38
9895	10153	0	2023-04-04 15:05:38
9896	10156	0	2023-04-04 15:05:38
9897	10154	0	2023-04-04 15:05:38
9898	10157	0	2023-04-04 15:05:38
9899	10155	0	2023-04-04 15:05:38
\.


--
-- TOC entry 3214 (class 0 OID 165217)
-- Dependencies: 220
-- Data for Name: percpu_avg15; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.percpu_avg15 (id_percpu_avg15, hostid, value_percpu_avg15, time_percpu_avg15) FROM stdin;
10049	10119	0	2023-04-04 15:05:37
10050	10120	0.56	2023-04-04 15:05:37
10051	10121	0	2023-04-04 15:05:37
10052	10122	0	2023-04-04 15:05:37
10053	10125	0	2023-04-04 15:05:37
10054	10126	0	2023-04-04 15:05:37
10055	10127	0	2023-04-04 15:05:37
10056	10123	0	2023-04-04 15:05:37
10057	10084	1.09	2023-04-04 15:05:37
10058	10124	0	2023-04-04 15:05:37
10059	10128	0	2023-04-04 15:05:37
10060	10129	0	2023-04-04 15:05:37
10061	10130	0	2023-04-04 15:05:37
10062	10131	0	2023-04-04 15:05:37
10063	10132	0	2023-04-04 15:05:37
10064	10133	0	2023-04-04 15:05:37
10065	10134	0	2023-04-04 15:05:37
10066	10135	0	2023-04-04 15:05:37
10067	10136	0	2023-04-04 15:05:37
10068	10137	0	2023-04-04 15:05:37
10069	10138	0	2023-04-04 15:05:37
10070	10139	0	2023-04-04 15:05:37
10071	10140	0	2023-04-04 15:05:37
10072	10141	0	2023-04-04 15:05:37
10073	10142	0	2023-04-04 15:05:37
10074	10143	0	2023-04-04 15:05:37
10075	10144	0	2023-04-04 15:05:37
10076	10145	0	2023-04-04 15:05:37
10077	10146	0	2023-04-04 15:05:37
10078	10147	0	2023-04-04 15:05:37
10079	10148	0	2023-04-04 15:05:37
10080	10149	0	2023-04-04 15:05:37
10081	10150	0	2023-04-04 15:05:37
10082	10151	0	2023-04-04 15:05:37
10083	10152	0	2023-04-04 15:05:37
10084	10153	0	2023-04-04 15:05:37
10085	10156	0	2023-04-04 15:05:37
10086	10154	0	2023-04-04 15:05:37
10087	10157	0	2023-04-04 15:05:37
10088	10155	0	2023-04-04 15:05:37
\.


--
-- TOC entry 3215 (class 0 OID 165222)
-- Dependencies: 221
-- Data for Name: percpu_avg5; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.percpu_avg5 (id_percpu_avg5, hostid, value_percpu_avg5, time_percpu_avg5) FROM stdin;
9854	10119	0	2023-04-04 15:05:38
9855	10120	0.18	2023-04-04 15:05:38
9856	10121	0	2023-04-04 15:05:38
9857	10122	0	2023-04-04 15:05:38
9858	10125	0	2023-04-04 15:05:38
9859	10126	0	2023-04-04 15:05:38
9860	10127	0	2023-04-04 15:05:38
9861	10123	0	2023-04-04 15:05:38
9862	10084	0.71	2023-04-04 15:05:38
9863	10124	0	2023-04-04 15:05:38
9864	10128	0	2023-04-04 15:05:38
9865	10129	0	2023-04-04 15:05:38
9866	10130	0	2023-04-04 15:05:38
9867	10131	0	2023-04-04 15:05:38
9868	10132	0	2023-04-04 15:05:38
9869	10133	0	2023-04-04 15:05:38
9870	10134	0	2023-04-04 15:05:38
9871	10135	0	2023-04-04 15:05:38
9872	10136	0	2023-04-04 15:05:38
9873	10137	0	2023-04-04 15:05:38
9874	10138	0	2023-04-04 15:05:38
9875	10139	0	2023-04-04 15:05:38
9876	10140	0	2023-04-04 15:05:38
9877	10141	0	2023-04-04 15:05:38
9878	10142	0	2023-04-04 15:05:38
9879	10143	0	2023-04-04 15:05:38
9880	10144	0	2023-04-04 15:05:38
9881	10145	0	2023-04-04 15:05:38
9882	10146	0	2023-04-04 15:05:38
9883	10147	0	2023-04-04 15:05:38
9884	10148	0	2023-04-04 15:05:38
9885	10149	0	2023-04-04 15:05:38
9886	10150	0	2023-04-04 15:05:38
9887	10151	0	2023-04-04 15:05:38
9888	10152	0	2023-04-04 15:05:38
9889	10153	0	2023-04-04 15:05:38
9890	10156	0	2023-04-04 15:05:38
9891	10154	0	2023-04-04 15:05:38
9892	10157	0	2023-04-04 15:05:38
9893	10155	0	2023-04-04 15:05:38
\.


--
-- TOC entry 3216 (class 0 OID 165227)
-- Dependencies: 222
-- Data for Name: size_free; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.size_free (id_size_free, hostid, value_size_free, time_size_free) FROM stdin;
5426	10084	12930453504	2023-04-04 15:05:40
5427	10119	0	2023-04-04 15:05:40
5428	10121	0	2023-04-04 15:05:40
5429	10122	0	2023-04-04 15:05:40
5430	10124	0	2023-04-04 15:05:40
5431	10120	14449844224	2023-04-04 15:05:40
5432	10123	0	2023-04-04 15:05:40
5433	10125	0	2023-04-04 15:05:40
5434	10126	0	2023-04-04 15:05:40
5435	10128	0	2023-04-04 15:05:40
5436	10127	0	2023-04-04 15:05:40
5437	10134	0	2023-04-04 15:05:40
5438	10131	0	2023-04-04 15:05:40
5439	10136	0	2023-04-04 15:05:40
5440	10129	0	2023-04-04 15:05:40
5441	10130	0	2023-04-04 15:05:40
5442	10132	0	2023-04-04 15:05:40
5443	10133	0	2023-04-04 15:05:40
5444	10135	0	2023-04-04 15:05:40
5445	10151	0	2023-04-04 15:05:40
5446	10152	0	2023-04-04 15:05:40
5447	10155	0	2023-04-04 15:05:40
\.


--
-- TOC entry 3217 (class 0 OID 165232)
-- Dependencies: 223
-- Data for Name: size_total; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.size_total (id_size_total, hostid, value_size_total, time_size_total) FROM stdin;
5426	10084	0	2023-04-04 15:05:41
5427	10119	0	2023-04-04 15:05:41
5428	10121	0	2023-04-04 15:05:41
5429	10122	0	2023-04-04 15:05:41
5430	10124	0	2023-04-04 15:05:41
5431	10120	20091629568	2023-04-04 15:05:41
5432	10123	0	2023-04-04 15:05:41
5433	10125	0	2023-04-04 15:05:41
5434	10126	0	2023-04-04 15:05:41
5435	10127	0	2023-04-04 15:05:41
5436	10128	0	2023-04-04 15:05:41
5437	10134	0	2023-04-04 15:05:41
5438	10131	0	2023-04-04 15:05:41
5439	10136	0	2023-04-04 15:05:41
5440	10129	0	2023-04-04 15:05:41
5441	10130	0	2023-04-04 15:05:41
5442	10132	0	2023-04-04 15:05:41
5443	10133	0	2023-04-04 15:05:41
5444	10135	0	2023-04-04 15:05:41
5445	10151	0	2023-04-04 15:05:41
5446	10152	0	2023-04-04 15:05:41
5447	10155	0	2023-04-04 15:05:41
\.


--
-- TOC entry 3218 (class 0 OID 165242)
-- Dependencies: 224
-- Data for Name: triggers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.triggers (triggerid, triggers_expression, description, priority, hostid) FROM stdin;
13800	{ARM01:agent.ping.nodata(5m)}=1	Сборщик данных на ARM01 недоступен более 5 минут	3	10119
13836	{ARM03:agent.ping.nodata(5m)}=1	Сборщик данных на ARM03 недоступен более 5 минут	3	10121
13853	{ARM04:agent.ping.nodata(5m)}=1	Сборщик данных на ARM04 недоступен более 5 минут	3	10122
13875	{ARM05:agent.ping.nodata(5m)}=1	Сборщик данных на ARM05 недоступен более 5 минут	3	10123
13892	{ARM06:agent.ping.nodata(5m)}=1	Сборщик данных на ARM06 недоступен более 5 минут	3	10124
13907	{ARM07:agent.ping.nodata(5m)}=1	Сборщик данных на ARM07 недоступен более 5 минут	3	10125
13936	{ARM17:agent.ping.nodata(5m)}=1	Сборщик данных на ARM17 недоступен более 5 минут	3	10126
13953	{ARM08:agent.ping.nodata(5m)}=1	Сборщик данных на ARM08 недоступен более 5 минут	3	10127
13970	{ARM09:agent.ping.nodata(5m)}=1	Сборщик данных на ARM09 недоступен более 5 минут	3	10128
13987	{ARM10:agent.ping.nodata(5m)}=1	Сборщик данных на ARM10 недоступен более 5 минут	3	10129
14004	{ARM11:agent.ping.nodata(5m)}=1	Сборщик данных на ARM11 недоступен более 5 минут	3	10130
14021	{ARM12:agent.ping.nodata(5m)}=1	Сборщик данных на ARM12 недоступен более 5 минут	3	10131
14038	{ARM13:agent.ping.nodata(5m)}=1	Сборщик данных на ARM13 недоступен более 5 минут	3	10132
14055	{ARM14:agent.ping.nodata(5m)}=1	Сборщик данных на ARM14 недоступен более 5 минут	3	10133
14072	{ARM15:agent.ping.nodata(5m)}=1	Сборщик данных на ARM15 недоступен более 5 минут	3	10134
14089	{ARM16:agent.ping.nodata(5m)}=1	Сборщик данных на ARM16 недоступен более 5 минут	3	10135
14108	{ARM18:agent.ping.nodata(5m)}=1	Сборщик данных на ARM18 недоступен более 5 минут	3	10136
14146	{ARM19:agent.ping.nodata(5m)}=1	Сборщик данных на ARM19 недоступен более 5 минут	3	10137
14163	{ARM20:agent.ping.nodata(5m)}=1	Сборщик данных на ARM20 недоступен более 5 минут	3	10138
14180	{ARM21:agent.ping.nodata(5m)}=1	Сборщик данных на ARM21 недоступен более 5 минут	3	10139
14197	{ARM22:agent.ping.nodata(5m)}=1	Сборщик данных на ARM22 недоступен более 5 минут	3	10140
14212	{ARM23:agent.ping.nodata(5m)}=1	Сборщик данных на ARM23 недоступен более 5 минут	3	10141
14229	{ARM24:agent.ping.nodata(5m)}=1	Сборщик данных на ARM24 недоступен более 5 минут	3	10142
14246	{ARM25:agent.ping.nodata(5m)}=1	Сборщик данных на ARM25 недоступен более 5 минут	3	10143
14265	{ARM26:agent.ping.nodata(5m)}=1	Сборщик данных на ARM26 недоступен более 5 минут	3	10144
14282	{ARM27:agent.ping.nodata(5m)}=1	Сборщик данных на ARM27 недоступен более 5 минут	3	10145
14297	{ARM28:agent.ping.nodata(5m)}=1	Сборщик данных на ARM28 недоступен более 5 минут	3	10146
14314	{ARM29:agent.ping.nodata(5m)}=1	Сборщик данных на ARM29 недоступен более 5 минут	3	10147
14333	{ARM30:agent.ping.nodata(5m)}=1	Сборщик данных на ARM30 недоступен более 5 минут	3	10148
14348	{ARM31:agent.ping.nodata(5m)}=1	Сборщик данных на ARM31 недоступен более 5 минут	3	10149
14367	{ARM32:agent.ping.nodata(5m)}=1	Сборщик данных на ARM32 недоступен более 5 минут	3	10150
14384	{MC2:agent.ping.nodata(5m)}=1	Сборщик данных на MC2 недоступен более 5 минут	3	10151
14401	{CC1:agent.ping.nodata(5m)}=1	Сборщик данных на CC1 недоступен более 5 минут	3	10152
14418	{MC3:agent.ping.nodata(5m)}=1	Сборщик данных на MC3 недоступен более 5 минут	3	10153
14452	{MC4:agent.ping.nodata(5m)}=1	Сборщик данных на MC4 недоступен более 5 минут	3	10154
14486	{CC2:agent.ping.nodata(5m)}=1	Сборщик данных на CC2 недоступен более 5 минут	3	10155
14435	{CC3:agent.ping.nodata(5m)}=1	Сборщик данных на CC3 недоступен более 5 минут	3	10156
14469	{CC4:agent.ping.nodata(5m)}=1	Сборщик данных на CC4 недоступен более 5 минут	3	10157
\.


--
-- TOC entry 3249 (class 0 OID 0)
-- Dependencies: 233
-- Name: User_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."User_id_user_seq"', 15, true);


--
-- TOC entry 3250 (class 0 OID 0)
-- Dependencies: 202
-- Name: cpu_interrupt_id_cpu_interrupt_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_interrupt_id_cpu_interrupt_seq', 9851, true);


--
-- TOC entry 3251 (class 0 OID 0)
-- Dependencies: 203
-- Name: cpu_lowait_id_cpu_lowait_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_lowait_id_cpu_lowait_seq', 9851, true);


--
-- TOC entry 3252 (class 0 OID 0)
-- Dependencies: 205
-- Name: cpu_nice_id_cpu_nice_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_nice_id_cpu_nice_seq', 9851, true);


--
-- TOC entry 3253 (class 0 OID 0)
-- Dependencies: 207
-- Name: cpu_softirq_id_cpu_softirq_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_softirq_id_cpu_softirq_seq', 9851, true);


--
-- TOC entry 3254 (class 0 OID 0)
-- Dependencies: 209
-- Name: cpu_steal_id_cpu_steal_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_steal_id_cpu_steal_seq', 9851, true);


--
-- TOC entry 3255 (class 0 OID 0)
-- Dependencies: 211
-- Name: cpu_system_id_cpu_system_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_system_id_cpu_system_seq', 9851, true);


--
-- TOC entry 3256 (class 0 OID 0)
-- Dependencies: 213
-- Name: cpu_util_idle_id_cpu_util_idle_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_util_idle_id_cpu_util_idle_seq', 9853, true);


--
-- TOC entry 3257 (class 0 OID 0)
-- Dependencies: 215
-- Name: cpu_util_user_id_cpu_util_user_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cpu_util_user_id_cpu_util_user_seq', 9893, true);


--
-- TOC entry 3258 (class 0 OID 0)
-- Dependencies: 226
-- Name: memory_available_id_memory_available_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.memory_available_id_memory_available_seq', 9853, true);


--
-- TOC entry 3259 (class 0 OID 0)
-- Dependencies: 227
-- Name: memory_total_id_memory_total_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.memory_total_id_memory_total_seq', 9853, true);


--
-- TOC entry 3260 (class 0 OID 0)
-- Dependencies: 228
-- Name: percpu_avg15_id_percpu_avg15_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.percpu_avg15_id_percpu_avg15_seq', 10088, true);


--
-- TOC entry 3261 (class 0 OID 0)
-- Dependencies: 229
-- Name: percpu_avg1_id_percpu_avg1_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.percpu_avg1_id_percpu_avg1_seq', 9899, true);


--
-- TOC entry 3262 (class 0 OID 0)
-- Dependencies: 230
-- Name: percpu_avg5_id_percpu_avg5_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.percpu_avg5_id_percpu_avg5_seq', 9893, true);


--
-- TOC entry 3263 (class 0 OID 0)
-- Dependencies: 231
-- Name: size_free_id_size_free_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.size_free_id_size_free_seq', 5447, true);


--
-- TOC entry 3264 (class 0 OID 0)
-- Dependencies: 232
-- Name: size_total_id_size_total_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.size_total_id_size_total_seq', 5447, true);


--
-- TOC entry 3043 (class 2606 OID 165421)
-- Name: User pk_1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT pk_1 PRIMARY KEY (id_user);


--
-- TOC entry 3011 (class 2606 OID 165282)
-- Name: cpu_interrupt pk_cpu_interrupt; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_interrupt
    ADD CONSTRAINT pk_cpu_interrupt PRIMARY KEY (id_cpu_interrupt);


--
-- TOC entry 3009 (class 2606 OID 165284)
-- Name: cpu_Iowait pk_cpu_lowait; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."cpu_Iowait"
    ADD CONSTRAINT pk_cpu_lowait PRIMARY KEY ("id_cpu_Iowait");


--
-- TOC entry 3013 (class 2606 OID 165286)
-- Name: cpu_nice pk_cpu_nice; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_nice
    ADD CONSTRAINT pk_cpu_nice PRIMARY KEY (id_cpu_nice);


--
-- TOC entry 3015 (class 2606 OID 165288)
-- Name: cpu_softirq pk_cpu_softirq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_softirq
    ADD CONSTRAINT pk_cpu_softirq PRIMARY KEY (id_cpu_softirq);


--
-- TOC entry 3017 (class 2606 OID 165290)
-- Name: cpu_steal pk_cpu_steal; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_steal
    ADD CONSTRAINT pk_cpu_steal PRIMARY KEY (id_cpu_steal);


--
-- TOC entry 3019 (class 2606 OID 165292)
-- Name: cpu_system pk_cpu_system; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_system
    ADD CONSTRAINT pk_cpu_system PRIMARY KEY (id_cpu_system);


--
-- TOC entry 3021 (class 2606 OID 165294)
-- Name: cpu_util_idle pk_cpu_util_idle; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_util_idle
    ADD CONSTRAINT pk_cpu_util_idle PRIMARY KEY (id_cpu_util_idle);


--
-- TOC entry 3023 (class 2606 OID 165296)
-- Name: cpu_util_user pk_cpu_util_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_util_user
    ADD CONSTRAINT pk_cpu_util_user PRIMARY KEY (id_cpu_util_user);


--
-- TOC entry 3025 (class 2606 OID 165298)
-- Name: host pk_host; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.host
    ADD CONSTRAINT pk_host PRIMARY KEY (hostid);


--
-- TOC entry 3027 (class 2606 OID 165300)
-- Name: memory_available pk_memory_available; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_available
    ADD CONSTRAINT pk_memory_available PRIMARY KEY (id_memory_available);


--
-- TOC entry 3029 (class 2606 OID 165302)
-- Name: memory_total pk_memory_total; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_total
    ADD CONSTRAINT pk_memory_total PRIMARY KEY (id_memory_total);


--
-- TOC entry 3031 (class 2606 OID 165304)
-- Name: percpu_avg1 pk_percpu_avg1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg1
    ADD CONSTRAINT pk_percpu_avg1 PRIMARY KEY (id_percpu_avg1);


--
-- TOC entry 3033 (class 2606 OID 165306)
-- Name: percpu_avg15 pk_percpu_avg15; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg15
    ADD CONSTRAINT pk_percpu_avg15 PRIMARY KEY (id_percpu_avg15);


--
-- TOC entry 3035 (class 2606 OID 165308)
-- Name: percpu_avg5 pk_percpu_avg5; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg5
    ADD CONSTRAINT pk_percpu_avg5 PRIMARY KEY (id_percpu_avg5);


--
-- TOC entry 3037 (class 2606 OID 165310)
-- Name: size_free pk_size_free; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_free
    ADD CONSTRAINT pk_size_free PRIMARY KEY (id_size_free);


--
-- TOC entry 3039 (class 2606 OID 165312)
-- Name: size_total pk_size_total; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_total
    ADD CONSTRAINT pk_size_total PRIMARY KEY (id_size_total);


--
-- TOC entry 3041 (class 2606 OID 165314)
-- Name: triggers pk_triggers; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.triggers
    ADD CONSTRAINT pk_triggers PRIMARY KEY (triggerid);


--
-- TOC entry 3045 (class 2606 OID 181521)
-- Name: User unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "unique" UNIQUE (login);


--
-- TOC entry 3047 (class 2606 OID 165315)
-- Name: cpu_interrupt cpu_interrupt_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_interrupt
    ADD CONSTRAINT cpu_interrupt_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3046 (class 2606 OID 165320)
-- Name: cpu_Iowait cpu_lowait_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."cpu_Iowait"
    ADD CONSTRAINT cpu_lowait_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3048 (class 2606 OID 165325)
-- Name: cpu_nice cpu_nice_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_nice
    ADD CONSTRAINT cpu_nice_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3049 (class 2606 OID 165330)
-- Name: cpu_softirq cpu_softirq_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_softirq
    ADD CONSTRAINT cpu_softirq_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3050 (class 2606 OID 165335)
-- Name: cpu_steal cpu_steal_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_steal
    ADD CONSTRAINT cpu_steal_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3051 (class 2606 OID 165340)
-- Name: cpu_system cpu_system_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_system
    ADD CONSTRAINT cpu_system_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3052 (class 2606 OID 165345)
-- Name: cpu_util_idle cpu_util_idle_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_util_idle
    ADD CONSTRAINT cpu_util_idle_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3053 (class 2606 OID 165350)
-- Name: cpu_util_user cpu_util_user_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cpu_util_user
    ADD CONSTRAINT cpu_util_user_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3054 (class 2606 OID 165355)
-- Name: memory_available memory_available_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_available
    ADD CONSTRAINT memory_available_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3055 (class 2606 OID 165360)
-- Name: memory_total memory_total_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.memory_total
    ADD CONSTRAINT memory_total_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3057 (class 2606 OID 165365)
-- Name: percpu_avg15 percpu_avg15_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg15
    ADD CONSTRAINT percpu_avg15_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3056 (class 2606 OID 165370)
-- Name: percpu_avg1 percpu_avg1_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg1
    ADD CONSTRAINT percpu_avg1_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3058 (class 2606 OID 165375)
-- Name: percpu_avg5 percpu_avg5_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.percpu_avg5
    ADD CONSTRAINT percpu_avg5_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3059 (class 2606 OID 165380)
-- Name: size_free size_free_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_free
    ADD CONSTRAINT size_free_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3060 (class 2606 OID 165385)
-- Name: size_total size_total_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.size_total
    ADD CONSTRAINT size_total_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


--
-- TOC entry 3061 (class 2606 OID 165390)
-- Name: triggers triggers_hostid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.triggers
    ADD CONSTRAINT triggers_hostid_fkey FOREIGN KEY (hostid) REFERENCES public.host(hostid);


-- Completed on 2023-04-10 20:23:02

--
-- PostgreSQL database dump complete
--

