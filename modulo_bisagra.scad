/******************************************************/
/* peristaltic extruder for 3d printing     		  */
/* file: modulo_bisagra.scad			 		      */
/* author: luis rodriguez				 	          */
/* version: 0.2						 		          */
/* w3b: tiny.cc/lyu     					 		  */
/* info:				    				 		  */
/******************************************************/
// @todo: - 

// Soporte lateral de cierre para el extrusor
//bisagra_extrusor();

altura = 10;
radio_exterior = 36;
radio_interior = 24;

radio_tubo = 2;   // grosor tubo presionado
radio_tubo_real = 3.25;

radio_entrada_tubo = 2.5;

ancho_boquilla = 15;
largo_boquilla = 30;

radio_bisagra = 8;
diametro_tornillo = 3.4;

suavizar_salida_tubo = 10;
grosor_pared_exterior_tubo_boquilla = 1;

g_tope_cojinetes = 1;
bisel_cojinete = 1;

/*~~ Pieza ~~*/

difference(){
    union(){
        mirror([0, 1, 0]) {
            media_bisagra_sin_eje(  radio_interior = radio_interior, radio_exterior = radio_exterior, 
                largo_boquilla = largo_boquilla, ancho_boquilla = ancho_boquilla, 
                altura = altura / 2 , radio_tubo = radio_tubo, g_tope_cojinetes = g_tope_cojinetes,
                radio_tubo_real = radio_tubo_real, bisel_cojinete = bisel_cojinete );
        }
        translate([0, - radio_interior/4, 0]) {
            media_bisagra_con_eje(  radio_interior = radio_interior, radio_exterior = radio_exterior, 
                largo_boquilla = largo_boquilla, ancho_boquilla = ancho_boquilla, 
                altura = altura / 2 , radio_tubo = radio_tubo, g_tope_cojinetes = g_tope_cojinetes,
                radio_tubo_real = radio_tubo_real , bisel_cojinete = bisel_cojinete );   
        }
    }
// Cortando la boquilla
translate([radio_exterior - 2, 0, 0])
    cube(size=[diametro_tornillo, ancho_boquilla * 3, 10], center=false);

//Reducir grosor boquilla
translate([radio_exterior + diametro_tornillo * 4, ancho_boquilla, altura -  bisel_cojinete])
    cube(size=[largo_boquilla, ancho_boquilla * 2, 10], center=true);
}

/*~~ Módulos ~~*/

/* Módulos para probar bomba con paredes cuadradas */
module media_bisagra_sin_eje( radio_interior = 24, radio_exterior = 36, largo_boquilla = 20,
    ancho_boquilla = 10, altura = 10, radio_tubo = 3.5, g_tope_cojinetes = 1, radio_tubo_real = 3.5, bisel_cojinete = 1
){
    difference(){
        difference(){
            union(){
                // Semi ciculo central
                difference(){
                    // exterior
                    cylinder( r = radio_exterior, altura, $fn = 100 ); 
                    // interior
                    cylinder(r = radio_interior - bisel_cojinete, altura, $fn = 100 ); 
                }
                // boquilla
                color("red")
                translate( [ radio_exterior + largo_boquilla / 2 - ( radio_exterior - radio_interior ), 0 , altura / 2 ] ) 
                cube( [ largo_boquilla , ancho_boquilla * 2 , altura ] , center=true ); 
            }
            // Taladro boquilla
            color("blue")
            translate([radio_exterior, -radio_tubo_real, altura])
            rotate([0, 90, 0])
            cylinder(r=radio_tubo_real, h=largo_boquilla * 2, center=true, $fn = 30);
            // Taladro camino interior del tubo
            translate([0, 0, g_tope_cojinetes ])
            cylinder(r = radio_interior + radio_tubo, altura, $fn = 100 ); 
            // holders drills
            translate([radio_interior + 3*largo_boquilla / 4, -(ancho_boquilla + 2 * radio_tubo_real) / 2 , 0])
            cylinder(r = diametro_tornillo / 2 , h=altura * 4, $fn = 20, center=true);
        }
        // ESTA PARTE ES MUUUUUU GUARRA AJUSTANDO A OJO!!
        translate([ radio_interior + suavizar_salida_tubo + radio_tubo_real - 2, 
            - ( suavizar_salida_tubo + radio_tubo_real * 3 - 1.5), 
            radio_tubo_real + grosor_pared_exterior_tubo_boquilla ]) {
            intersection(){
                // cuadrado extruido
                rotate_extrude(convexity = 10)
                translate([ suavizar_salida_tubo + radio_tubo_real * 2, 0 , 0 ] )
                square(size=[radio_tubo_real * 2 , radio_tubo_real * 2], center = true);

                    // Cuadrado que representa la parte que queremos quedarnos del toroide para encajarla en la salida del tubo    
                    translate([-( suavizar_salida_tubo + radio_tubo_real * 4 ) / 2, 
                        ( suavizar_salida_tubo + radio_tubo_real * 4 ) / 2 , 0])
                    cube(size = [ suavizar_salida_tubo + radio_tubo_real * 4, 
                        suavizar_salida_tubo + radio_tubo_real * 1, altura * 2 ] , center = true ); 
                }
            }
            // Eliminar la parte "mirror" para que darnos con la mitad de la pieza
            color("brown")
            translate( [ - radio_exterior , 0 , 0 ] ) 
            cube( [ ( radio_exterior + altura + largo_boquilla ) * 2, radio_exterior , altura ] ); 
        }
    }


    module media_bisagra_con_eje( radio_interior = 24, radio_exterior = 36, largo_boquilla = 20,
        ancho_boquilla = 10, altura = 10, radio_tubo = 3.5, g_tope_cojinetes = 1, radio_tubo_real = 3.5, bisel_cojinete = 1
    ){
        difference(){
            difference(){
                union(){
                    // Semi ciculo central
                    difference(){
                        // exterior
                        cylinder( r = radio_exterior, altura, $fn = 100 ); 
                        // interior
                        cylinder(r = radio_interior - bisel_cojinete, altura, $fn = 100 ); 
                    }
                    // boquilla
                    color("red")
                    translate( [ radio_exterior + largo_boquilla / 2 - ( radio_exterior - radio_interior ), 0 , altura / 2 ] ) 
                    cube( [ largo_boquilla , ancho_boquilla * 2 , altura ] , center=true ); 

                    difference(){
                    // Cilindro de apoyo entre piezas para el giro ( cuerpo de la bisagra)
                    color("green")
                    translate( [ - ( radio_exterior + radio_bisagra ) , 0 , 0 ] )
                    cylinder(r = radio_bisagra, altura, $fn = 100);

                    // Taladro para el tornillo que hace de eje de la bisagra
                    color("black")
                    translate( [ - ( radio_exterior + radio_bisagra ) , 0 , altura/4 ] )
                    cylinder(r = diametro_tornillo/2, altura * 2, $fn = 100, center = true);                  
                }
// Enlace entre cuerpo y soporte de bisagra
color("lime")
linear_extrude(height =altura)
polygon( [ [ - ( radio_exterior + radio_bisagra ) ,  - radio_bisagra ] , [ -radio_exterior , 0  ] , 
    [ -radio_exterior * 0.707 , -radio_exterior * 0.707 ] ] , convexity = n);
}
            // Taladro boquilla
            color("blue")
            translate([radio_exterior, -radio_tubo_real, altura])
            rotate([0, 90, 0])
            cylinder(r=radio_tubo_real, h=largo_boquilla * 2, center=true, $fn = 30);

                        // holders drills
                        translate([radio_interior + 3*largo_boquilla / 4, -(ancho_boquilla + 2 * radio_tubo_real) / 2 , 0])
                        cylinder(r = diametro_tornillo / 2 , h=altura * 4, $fn = 20, center=true);

                // Taladro camino interior del tubo
                translate([0, 0, g_tope_cojinetes ]) {
                    cylinder(r = radio_interior + radio_tubo, altura, $fn = 100 ); 
                }
            }

            // ESTA PARTE ES MUUUUUU GUARRA AJUSTANDO A OJO!!
            translate([ radio_interior + suavizar_salida_tubo + radio_tubo_real - 2, 
                - ( suavizar_salida_tubo + radio_tubo_real * 3 - 1.5), 
                radio_tubo_real + grosor_pared_exterior_tubo_boquilla ]) {
                intersection(){
                    // cuadrado extruido
                    rotate_extrude(convexity = 10)
                    translate([ suavizar_salida_tubo + radio_tubo_real * 2, 0 , 0 ] )
                    union(){
                        square(size=[radio_tubo_real * 2 , radio_tubo_real * 2], center = true);
                    }
                    // Cuadrado que representa la parte que queremos quedarnos del toroide para encajarla en la salida del tubo    
                    translate([-( suavizar_salida_tubo + radio_tubo_real * 4 ) / 2, 
                        ( suavizar_salida_tubo + radio_tubo_real * 4 ) / 2 , 0])
                    cube(size = [ suavizar_salida_tubo + radio_tubo_real * 4, 
                        suavizar_salida_tubo + radio_tubo_real * 1, altura * 2 ] , center = true ); 
                }
            }
            // Eliminar la parte "mirror" para que darnos con la mitad de la pieza
            color("brown")
            translate( [ - radio_exterior , 0 , 0 ] ) 
            cube( [ ( radio_exterior + altura + largo_boquilla ) * 2, radio_exterior , altura ] ); 
        }
    }