#import "@preview/shadowed:0.2.0": shadowed
#import "@preview/hydra:0.6.0": hydra
#import "@preview/fletcher:0.5.7": *

#import "@preview/codly:1.3.0": *
#show: codly-init

#import "@preview/codly-languages:0.1.10": *
#codly(languages: codly-languages)

#import "@preview/cheq:0.3.0": checklist

#show: checklist.with(

  marker-map: (
    "t": emoji.bus,
    "f": emoji.bicyclist.mountain,
    "b": emoji.compass,
    "l": emoji.laptop,
    "r": emoji.book.open,
    "s": emoji.shovel,
  ),
)



#let myhighlight(content) = {
  highlight(
    fill: highlight-color,
    radius: 1pt,
    extent: 2pt,
    content,
  )
}


#set text(size: 12pt, lang: "es", font: "New Computer Modern")

// Header

#let header1 = [
  _Java basics_
]

#let header2 = [
CreadorSW --- *#smallcaps[v. 1.0]*
]

#set page(
  fill: white,
  margin: (top: 2.5cm, right: 2.5cm, left: 3cm, bottom: 3cm),
  header: context {
    grid(
      columns: (1fr, auto),
      [#header1],
      [#header2],
    )
    line(length: 100%)
  },
  numbering: "1 of 1"
)
// bold text
#show outline.entry.where(level: 1): set text(weight: "bold")
#outline()

#set par.line(numbering: "1")

//Guía de Conceptos Fundamentales de Java

Esta guía explica los conceptos básicos de Java comparándolos con Wollok, para facilitar la traducción de un lenguaje a otro.

#v(0.5em)

= Lo primero que llama la atención

Lo primero que llama la atención es la estructura de directorios.

#set text(font: "Hack")
`
wtoj-plataforma-contenidos-CreadorSW-1
    ├── mvnw
    ├── mvnw.cmd
    ├── pom.xml
    ├── README.md
    ├── src
    │   ├── main
    │   │   └── java
    │   │       └── ar
    │   │           └── edu
    │   │               └── unahur
    │   │                   └── obj2
    │   │                       └── w2j
    │   │                           ├── contenidos
    │   │                           │   ├── Contenido.java
    │   │                           │   ├── Peliculas.java
    │   │                           │   └── series
    │   │                           │       ├── Episodio.java
    │   │                           │       ├── Serie.java
    │   │                           │       └── Temporada.java
    │   │                           └── Main.java
    │   └── test
    │       └── java
`
#set text(font: "New Computer Modern")

- Esa estructura es porque seguimos la convención de Maven.
- Cada clase en Java va en un archivo `.java` que se escribe con mayúscula.
- El `Main.java` viene con el repo porque se necesita como punto de entrada (esto se explica en la sección correspondiente).
- `mvnw` y `mvnw.cmd`: Scripts que permiten usar Maven sin instalarlo globalmente. El primero es para Linux/Mac, el segundo para Windows.
- `pom.xml`: Archivo de configuración de Maven que define las dependencias y cómo compilar el proyecto.

== Gestión de Dependencias y Maven

Java utiliza herramientas como *Maven* para gestionar las librerías externas. Los editores modernos (como Zed) detectan automáticamente la configuración del proyecto:

- *Detección*: El servidor de lenguaje (JDT.LS) busca el archivo `pom.xml`. Si existe, configura el proyecto siguiendo el estándar de Maven.
- *Maven Wrapper (`mvnw`)*: Permite ejecutar Maven sin tenerlo instalado globalmente, asegurando que todos los desarrolladores usen la misma versión.
- *Repositorio Local*: Las dependencias se descargan una sola vez a la carpeta `~/.m2/repository`.
  - La primera compilación es lenta porque descarga todo de internet.
  - Las siguientes son rápidas porque Maven reutiliza lo que ya tiene en disco.
  - Esto permite trabajar offline una vez que las dependencias iniciales fueron obtenidas.

#v(0.5em)

= Ignorando archivos de compilación (.gitignore)

Cuando subís el proyecto a Git, *no* deben incluirse los archivos generados automáticamente:

- `target/`: Directorio donde Maven guarda los `.class` compilados y los resultados de los tests. Puede ocupar varios megabytes.
- `*.class`: Archivos de bytecode Java, por si compilás un archivo suelto a mano fuera de Maven.

Estos archivos *no* deben subirse porque:
- Son generados automáticamente desde cualquier código fuente.
- Ocupan espacio innecesario.
- Cada desarrollador los genera localmente al compilar.

Todo lo demás *debe quedarse* en el repositorio:
- `.mvn/`, `mvnw`, `mvnw.cmd`, `pom.xml`, `src/`

Esto se configura en un archivo `.gitignore` en la raíz del proyecto.

#v(0.5em)

= Sintaxis Básica

== Llaves `{}` en vez de indentación

En Java, las llaves `{}` definen los bloques de código (clases, métodos, condiciones). La indentación es solo visual, no sintáctica.

#codly(zebra-fill: none)
*Java:*
#codly(languages: codly-languages)
```java
public class Contenido {
    private String titulo;
    private int costoBase;

    public int costo() {
        return this.costoBase;
    }
}
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
class Contenido {
    const titulo
    var costoBase

    method costo() = costoBase
}
```

*¿Qué pasa si no usás las llaves?*

*Java:*
#codly(languages: codly-languages)
```java
public class Contenido {
    private String titulo  // ERROR: missing } at end of class
```

El compilador tira error de sintaxis porque no puede determinar dónde termina el bloque.

#v(0.5em)

== Punto y coma `;` obligatorio

Java requiere `;` al final de cada instrucción. Es obligatorio porque una línea puede contener varias instrucciones.

*Java:*
#codly(languages: codly-languages)
```java
int x = 5;
x = x + 1;
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
var x = 5
x = x + 1
```

*¿Qué pasa si no ponés `;`?*

*Java:*
#codly(languages: codly-languages)
```java
int x = 5  // ERROR: syntax error, insert ';' to complete statement
x = x + 1;
```

El compilador informa exactamente dónde falta el `;`.

#v(0.5em)

= Variables y Tipos

== Java es fuertemente tipado

En Java *siempre* debés indicar el tipo de la variable. No podés dejar que el compilador lo infiera.

*Java:*
#codly(languages: codly-languages)
```java
String titulo = "Recuerdos";
int costoBase = 20;
boolean esPopular = true;
double promedio = 22.5;
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
const titulo = "Recuerdos"
var costoBase = 20
var esPopular = true
var promedio = 22.5
```

*¿Qué pasa si usás un tipo incorrecto?*

*Java:*
#codly(languages: codly-languages)
```java
String titulo = 123;  // ERROR: incompatible types: int cannot be converted to String
```

El compilador detecta el error antes de ejecutar el programa.

== Inmutable vs Mutable

*Java:*
#codly(languages: codly-languages)
```java
final String titulo = "Recuerdos";  // no se puede cambiar (equivalente a const)
int costoBase = 20;                  // sí se puede cambiar (equivalente a var)
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
const titulo = "Recuerdos"   // inmutable
var costoBase = 20            // mutable
```

*¿Qué pasa si intentás modificar una variable `final`?*

*Java:*
#codly(languages: codly-languages)
```java
final String titulo = "Recuerdos";
titulo = "Otro título";  // ERROR: cannot assign a value to final variable titulo
```

El compilador lanza error de compilación.

#v(0.5em)

= Visibilidad (`public` / `private`)

== Por qué existe este concepto

El *encapsulamiento* protege los datos de modificaciones accidentales o incorrectas. Cada clase decide qué propiedades y métodos son accesibles desde afuera.

*Java:*
#codly(languages: codly-languages)
```java
public class Contenido {
    private String titulo;  // solo la clase Contenido lo ve

    public String getTitulo() {  // acceso controlado
        return this.titulo;
    }

    public void setTitulo(String nuevoTitulo) {  // validación antes de modificar
        this.titulo = nuevoTitulo;
    }
}
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
class Contenido {
    const titulo
    var costoBase
}
```

En Wollok no existe encapsulamiento: cualquiera puede ver y modificar cualquier atributo.

== ¿Qué pasa si no ponés modificador?

*Java:*
#codly(languages: codly-languages)
```java
class Contenido {
    String titulo;  // package-private (default)
}
```

Cualquier clase en el *mismo paquete* puede ver y modificar `titulo`. Es una vulnerabilidad porque se rompe el control sobre cómo se accede a los datos.

== Niveles de visibilidad

#set table(
    stroke: none,
    gutter: 0.2em,
    fill: (x, y) =>
      if y == 0  {
        gray
      } else if y > 0 {
        rgb("ffdfba").lighten(60%)
      },
    inset: (x: 0.5em, y: 1em),
)

#show table.cell: it => {
    if it.y == 0 {
      set text(
        size: 14pt,
        fill: white,
        weight: "bold"
      )
      it
    } else {
      it
    }
}
#show table.cell.where(x: 0): strong
#show table.cell.where(x: 1): strong

#table(
  columns: (auto, auto),
  table.header[Modificador][Alcance],

  [`public`],[Cualquier clase desde cualquier paquete],
  [`private`],[Solo dentro de la misma clase],
  [(ninguno)],[Package-private (solo clases del mismo paquete)],
)

#v(0.5em)

= Clases y Herencia

== Herencia con `extends`

*Java:*
#codly(languages: codly-languages)
```java
public class Pelicula extends Contenido {
    // hereda titulo y costoBase automáticamente
}
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
class Pelicula inherits Contenido {
    // vacía, hereda todo
}
```

*¿Qué pasa si heredás de una clase que no existe?*

*Java:*
#codly(languages: codly-languages)
```java
public class Pelicula extends Contenido { }
// ERROR: Contenido cannot be resolved to a type
```

El compilador no encuentra la clase padre.

== Clases abstractas

Una clase abstracta no se puede instanciar directamente. Sirve como base para otras clases.

*Java:*
#codly(languages: codly-languages)
```java
public abstract class Contenido {
    public abstract int costo();  // las subclases DEBEN implementar
}
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
class Contenido {
    method costo()  // sin cuerpo = abstracto
}
```

*¿Qué pasa si no implementás el método abstracto?*

*Java:*
#codly(languages: codly-languages)
```java
public class Pelicula extends Contenido {
    // ERROR: The type Pelicula must implement the inherited abstract method Contenido.costo()
}
```

El compilador obliga a implementar todos los métodos abstractos.

== Clases concretas (no abstractas)

*Java:*
#codly(languages: codly-languages)
```java
public class Pelicula extends Contenido {
    @Override
    public int costo() {
        return this.getCostoBase();
    }
}
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
class Pelicula inherits Contenido {
    // vacía, hereda el costo() de Contenido si existiera
}
```

#v(0.5em)

= Métodos

== `return` es obligatorio

Si declarás un método que devuelve algo, *debes* retornar un valor.

*Java:*
#codly(languages: codly-languages)
```java
public int costo() {
    return this.costoBase;
}
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
method costo() = costoBase
```

*¿Qué pasa si no ponés `return`?*

*Java:*
#codly(languages: codly-languages)
```java
public int costo() {
    costoBase;  // ERROR: missing return statement
}
```

El compilador detecta que el método promete devolver `int` pero no lo hace.

== `void` para métodos que no devuelven nada

*Java:*
#codly(languages: codly-languages)
```java
public void agregarTemporada(Temporada t) {
    temporadas.add(t);
}
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
method agregarTemporada(unaTemporada) {
    temporadas.add(unaTemporada)
}
```

*¿Qué pasa si intentás usar `return` en un método `void`?*

*Java:*
#codly(languages: codly-languages)
```java
public void agregarTemporada(Temporada t) {
    return true;  // ERROR: void methods cannot return a value
}
```

== Parámetros de métodos

*Java:*
#codly(languages: codly-languages)
```java
public void agregarTemporada(Temporada unaTemporada) {
    temporadas.add(unaTemporada);
}
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
method agregarTemporada(unaTemporada) {
    temporadas.add(unaTemporada)
}
```

#v(0.5em)

= Colecciones

== Java necesita tipo específico y `new`

*Java:*
#codly(languages: codly-languages)
```java
List<Temporada> temporadas = new ArrayList<>();
temporadas.add(unaTemporada);
temporadas.size();
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
const temporadas = []
temporadas.add(unaTemporada)
temporadas.size()
```

== Recorrer una colección

*Java:*
#codly(languages: codly-languages)
```java
int suma = temporadas.stream().mapToInt(t -> t.costo()).sum();
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
var suma = temporadas.sum({ t => t.costo() })
```

== Otros tipos de colecciones

*Java:*
#codly(languages: codly-languages)
```java
Set<String> titulos = new HashSet<>();
Map<String, Integer> duracion = new HashMap<>();
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
// Wollok no distingue entre Set, Map, List
// usa simplemente listas
const titulos = []
const duracion = []
```

#v(0.5em)

= Comparación Directa Wollok → Java

#set table(
    stroke: none,
    gutter: 0.2em,
    fill: (x, y) =>
      if y == 0  {
        gray
      } else if y > 0 {
        rgb("ffdfba").lighten(60%)
      },
    inset: (x: 0.5em, y: 1em),
)

#show table.cell: it => {
    if it.y == 0 {
      set text(
        size: 14pt,
        fill: white,
        weight: "bold"
      )
      it
    } else {
      it
    }
}
#show table.cell.where(x: 0): strong
#show table.cell.where(x: 1): strong

#table(
  columns: (auto, auto, auto),
  table.header[Concepto][Wollok][Java],

  [Inmutable],[`const`],[`final`],
  [Mutable],[`var`],[`tipo` (sin final)],
  [Herencia],[`class X inherits Y`],[`class X extends Y`],
  [Clase abstracta],[método sin cuerpo],[`abstract class X`],
  [Method abstracto],[`method costo()`],[`public abstract int costo()`],
  [Visibilidad],[no existe],[`public` / `private`],
  [Lista],[`[]`],[`new ArrayList<>()`],
  [Tamaño],[`.size()`],[`.size()`],
  [Sumar elementos],[`.sum({x => x.costo()})`],[`.stream().mapToInt(x -> x.costo()).sum()`],
  [Punto y coma],[opcional],[obligatorio],
  [Llaves],[no se usan],[obligatorias],
  [Constructor],[automático],[hay que escribirlo],
)

#v(0.5em)

= Override

En Java es *obligatorio* usar la anotación `@Override` cuando sobrescribís un método de la clase padre.

*Java:*
#codly(languages: codly-languages)
```java
@Override
public int costo() {
    return 3;
}
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
override method costo() {
    return 3
}
```

*¿Qué pasa si te olvidás `@Override`?*

*Java:*
#codly(languages: codly-languages)
```java
public int costo() {  // se supone que es override pero sin anotación
    return 3;
}
```

Si no es realmente un override (por ejemplo, si el método padre tiene otra firma), Java *no te avisa*. Podés tener un método completamente nuevo sin querer y el compilador no dice nada.

#v(0.5em)

= Main - Punto de Entrada

Todo programa Java necesita un método `main` como punto de entrada. Sin él, Java no sabe qué ejecutar primero.

#codly(languages: codly-languages)
```java
public static void main(String[] args) {
    // Acá empieza todo
}
```

== Main vacío - No hace nada

#codly(languages: codly-languages)
```java
public static void main(String[] args) {
    // vacío
}
```

El programa compila, corre, pero no pasa nada visible.

== Main que crea un Contenido y usa un método

#codly(languages: codly-languages)
```java
public static void main(String[] args) {
    Contenido pelicula = new Contenido("Recuerdos", 20);
    System.out.println(pelicula.costo());  // imprime 20
}
```

Resultado: `20`

== Main que crea Contenido y Pelicula

#codly(languages: codly-languages)
```java
public static void main(String[] args) {
    Contenido pelicula = new Contenido("Recuerdos", 20);
    Contenido otraPelicula = new Pelicula("Avatar", 30);

    System.out.println(pelicula.costo());       // 20
    System.out.println(otraPelicula.costo());    // 30
}
```

== Main que delega a otro método

El main nunca tiene toda la lógica. Solo crea objetos y delega.

#codly(languages: codly-languages)
```java
public static void main(String[] args) {
    Plataforma plataforma = new Plataforma();
    plataforma.iniciar();  // toda la lógica está en iniciar(), no acá
}
```

== ¿Cuánto código debe tener el main?

*Mínimo posible.* Solo crea objetos y delega. No pongas toda la lógica en el main.

*Mal:*
#codly(languages: codly-languages)
```java
public static void main(String[] args) {
    // 200 líneas de código todo mezclado
    // crear objetos
    // llamar métodos
    // hacer cálculos
    // imprimir resultados
}
```

*Bien:*
#codly(languages: codly-languages)
```java
public static void main(String[] args) {
    Plataforma plataforma = new Plataforma();
    plataforma.iniciar();
}
```

== Si tenés muchas acciones (como 50 tests)

Tenés tres opciones:

*Opción 1: Framework de testing (JUnit)*
No ponés nada en el main. Los tests son clases separadas con `@Test`. El framework los ejecuta.

*Opción 2: Clase Ejecutor separada*

#codly(languages: codly-languages)
```java
// Main.java
public class Main {
    public static void main(String[] args) {
        Ejecutor.ejecutarTodo();
    }
}

// Ejecutor.java
public class Ejecutor {
    public static void ejecutarTodo() {
        Contenido pelicula = new Contenido("Recuerdos", 20);
        System.out.println(pelicula.costo());
    }
}
```

*Opción 3: Métodos estáticos llamados desde main*
#codly(languages: codly-languages)
```java
public static void main(String[] args) {
    testCostoPelicula();
    testCostoSerie();
}

public static void testCostoPelicula() {
    Contenido pelicula = new Contenido("Recuerdos", 20);
    System.out.println(pelicula.costo());
}

public static void testCostoSerie() {
    // ...
}
```

== ¿Por qué existe el main?

Java no tiene un REPL como Wollok. Necesita saber *exactamente* dónde empieza. Sin `main`, no hay punto de partida.

== ¿Qué pasa si no tengo main?

```
Error: Main method not found in class Contenido, please define the main method as:
public static void main(String[] args)
```

#v(0.5em)

= Constructores

En Java, si necesitás inicializar objetos con parámetros, debés escribir el constructor explícitamente. Wollok lo hace automáticamente, Java no.

== Constructor en Java vs Wollok

*Java:*
#codly(languages: codly-languages)
```java
public class Contenido {
    private final String titulo;
    private double costoBase;

    public Contenido(String titulo, double costoBase) {
        this.titulo = titulo;
        this.costoBase = costoBase;
    }
}
```

*Wollok:*
#codly(languages: codly-languages)
```wollok
class Contenido {
    const titulo
    var costoBase
}
// Wollok genera automáticamente el constructor con los parámetros
```

== ¿Por qué `this`?

`this.titulo` significa "el campo titulo de este objeto". Sin `this`, Java no sabe si `titulo` se refiere al parámetro o al campo.

#codly(languages: codly-languages)
```java
public Contenido(String titulo, double costoBase) {
    this.titulo = titulo;          // this.titulo = campo, titulo = parámetro
    this.costoBase = costoBase;
}
```

== ¿Qué pasa si no escribís constructor?

#codly(languages: codly-languages)
```java
public class Contenido {
    private String titulo;
    private double costoBase;
}
// Java crea automáticamente: Contenido() {}
```

Si no definís ningún constructor, Java crea uno automático sin parámetros. Pero si definís *al menos uno con parámetros*, el automático desaparece.

== Constructor en clase abstracta

#codly(languages: codly-languages)
```java
public abstract class Contenido {
    private final String titulo;
    protected double costoBase;  // protected para que las subclases accedan

    public Contenido(String titulo, double costoBase) {
        this.titulo = titulo;
        this.costoBase = costoBase;
    }
}
```

== ¿Por qué `protected` en vez de `private`?

#set table(
    stroke: none,
    gutter: 0.2em,
    fill: (x, y) =>
      if y == 0  {
        gray
      } else if y > 0 {
        rgb("ffdfba").lighten(60%)
      },
    inset: (x: 0.5em, y: 1em),
)

#show table.cell: it => {
    if it.y == 0 {
      set text(
        size: 14pt,
        fill: white,
        weight: "bold"
      )
      it
    } else {
      it
    }
}
#show table.cell.where(x: 0): strong
#show table.cell.where(x: 1): strong

#table(
  columns: (auto, auto),
  table.header[Modificador][Quién puede verlo],

  [`private`],[Solo la clase misma],
  [`protected`],[La clase y sus subclases],
)

Si `costoBase` fuera `private`, `Pelicula` (que hereda de `Contenido`) no podría acceder a `costoBase`.

*Wollok:* No existe este concepto. Todos los atributos son accesibles.

== ¿Qué pasa si no escribís constructor y lo necesitás?

#codly(languages: codly-languages)
```java
Contenido c = new Contenido();  // ERROR: no default constructor exists
```

Si definiste un constructor con parámetros y necesitás el sin parámetros, debés escribirlo vos.
