#Data cleaning, y modificación de los tipos de datos. 
#1. se crea una copia de la base de datos original, evitando inconvenientes. 
#2. se identifica que datos son validos y cuales no, pensado en que un analisis posterior se hacen los siguientes ajustes. 

SELECT *
FROM per_sta
;

#Ajuste 1: se modifica la columna, pasa de numero a texto, facilita entendimiento 
#tambioen pasa de español a ingles

UPDATE per_sta
SET Gender = CASE
			WHEN Gender = 0 THEN 'Male'
            WHEN Gender = 1 THEN 'Female'
            ELSE Gender
		END;

UPDATE per_sta
SET Gender = CASE
			WHEN Gender = 'Masculino' THEN 'Male'
            WHEN Gender = 'Femenino' THEN 'Female'
            ELSE Gender
		END;

#ajuste 2: se actualizan datos de la etnia de cada estudiante, facilita el entendimiento en lugar de un listado de numeros
UPDATE per_sta
SET Ethnicity = CASE
			WHEN Ethnicity = 0 THEN 'Caucasian'
            WHEN Ethnicity = 1 THEN 'African American'
            WHEN Ethnicity = 2 THEN 'Asian'
            WHEN Ethnicity = 3 THEN 'Other'
            ELSE Ethnicity
		END;

# ajuste3: lo mismo que los anteriores
UPDATE per_sta
SET ParentalEducation = CASE
			WHEN ParentalEducation = 0 THEN 'None'
            WHEN ParentalEducation = 1 THEN 'High School'
            WHEN ParentalEducation = 2 THEN 'Tech/Associate'
            WHEN ParentalEducation = 3 THEN 'Bachelor´s'
            WHEN ParentalEducation = 4 THEN 'Higher'
            ELSE ParentalEducation
		END;

UPDATE per_sta
SET ParentalSupport = CASE
			WHEN ParentalSupport = 0 THEN 'None'
            WHEN ParentalSupport = 1 THEN 'Low'
            WHEN ParentalSupport = 2 THEN 'Moderate'
            WHEN ParentalSupport = 3 THEN 'High'
            WHEN ParentalSupport = 4 THEN 'Very high'
            ELSE ParentalSupport
		END;
        
ALTER TABLE per_sta
MODIFY COLUMN ParentalSupport VARCHAR(50);

#ajuste 4: el dato original contaba com +7 cifras despues del punto, se acorta a maximo 2 y se establece como tipo de dato decimal.
UPDATE per_sta
SET StudyTimeWeekly = ROUND(StudyTimeWeekly, 2);

UPDATE per_sta
SET GPA = ROUND(GPA, 2);

#Aca inicia el analisis de relaciones

#1. la educacion de los padres afecta en nivel de apoyo que le pueden brindar a sus hijos?

SELECT ParentalEducation, ParentalSupport, COUNT(*) AS count
FROM per_sta
Group by ParentalEducation, ParentalSupport
oRDER BY ParentalEducation, ParentalSupport;


-- Paso 1: Crear una tabla de contingencia, se compara el PE, PS y se saca el pocentaje de cada uno respecto a la cantidad de estudiantes
WITH Contingencia AS (
    SELECT
        ParentalEducation,
        ParentalSupport,
        COUNT(*) AS count
    FROM
       per_sta
    GROUP BY
		ParentalEducation, ParentalSupport
),
-- Paso 2: Calcular el total de registros
Totales AS (
    SELECT
        COUNT(*) AS total_count
    FROM
        per_sta
)
-- Paso 3: Mostrar la tabla de contingencia con porcentajes
SELECT
    c.ParentalEducation,
    c.ParentalSupport,
    c.count,
    (c.count * 100.0 / t.total_count) AS percentage
FROM
    Contingencia c,
    Totales t
ORDER BY
    c.ParentalEducation, c.ParentalSupport;


    
SELECT ParentalEducation, ParentalSupport, COUNT(*) AS count
FROM per_sta
Group by ParentalEducation, ParentalSupport
oRDER BY ParentalEducation, ParentalSupport;


#promedio de horas estudiadas por genero
SELECT Gender, AVG(StudyTimeWeekly)
FROM per_sta
GROUP BY Gender;

#promedio de horas estudiadas por grado(gradeclass)
SELECT GradeClass, AVG(StudyTimeWeekly)
FROM per_sta
GROUP BY GradeClass
ORDER BY GradeClass ASC;

#apoyo de los padres por grade class
SELECT ParentalSupport, GradeClass, count(*) AS count
FROM per_sta
GROUP BY ParentalSupport, GradeClass
ORDER BY ParentalSupport, GradeClass
;

#Distribución de genero por grade class
SELECT GradeClass, Gender,count(*) AS count
FROM per_sta
WHERE Gender = 'Male'
GROUP BY GradeClass, Gender 
ORDER BY GradeClass, Gender;

SELECT GradeClass, Gender,count(*) AS count
FROM per_sta
WHERE Gender = 'Female'
GROUP BY GradeClass, Gender 
ORDER BY GradeClass, Gender;

SELECT GradeClass, Gender,count(*) AS count
FROM per_sta
GROUP BY GradeClass, Gender 
ORDER BY GradeClass, Gender;

#ver distribución de tiempos, usado para observar si la participación de voluntariado o extracurriculares afecta el tiempo de estudio semanal

SELECT Extracurricular, Volunteering, AVG(StudyTimeWeekly), count(*) AS count
FROM per_sta
GROUP BY Extracurricular, Volunteering
ORDER BY Extracurricular, Volunteering
;

#pormedio de ausencias por grado
SELECT Absences, GradeClass, count(*) AS count
FROM per_sta
GROUP BY Absences, GradeClass
ORDER BY Absences, GradeClass
;

#factores sociales y su efecto en las notas
SELECT ParentalEducation, ParentalSupport, GradeClass, COUNT(*) AS count
FROM per_sta
Group by ParentalEducation, ParentalSupport, GradeClass
oRDER BY ParentalEducation, ParentalSupport;

#conteo de estudiantes por agrupación de notas
SELECT distinct GradeClass, count(*) AS conteo
From per_sta
GROUP BY GradeClass
Order by GradeClass;

#agrupación de los grados por las diferentes categorias de apoyo parental. 
SELECT 
    ParentalSupport, 
    GradeClass, 
    COUNT(*) AS count
FROM 
    per_sta
GROUP BY 
    ParentalSupport, 
    GradeClass
ORDER BY 
    CASE 
        WHEN ParentalSupport = 'Very high' THEN 1
        WHEN ParentalSupport = 'High' THEN 2
        WHEN ParentalSupport = 'Moderate' THEN 3
        WHEN ParentalSupport = 'Low' THEN 4
        WHEN ParentalSupport = 'None' THEN 5
        ELSE 6  -- Opcional, para manejar casos inesperados
    END,
    GradeClass;
 
#comparación estudio semanal con los grados. 
SELECT StudyTimeWeekly, GradeClass 
FROM per_sta
;




