/*
 * box.scad
 * 
 * Copyright 2017 marcell marosvolgyi <marcell@transistordyne.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301, USA.
 * 
 * 
 * Usage: halfcube(X, Y, Z, Nx, Ny, Nz, d)
 * where X, Y, Z is cart dim and Nx, Ny, Nz is number of teeth, d is plate thickness
 * 
 */

golden = (1+sqrt(5))/2;

function flatten(l) = [ for (a = l) for (b = a) b ] ;

module side(X, Y, Nx, Ny, d, fill=true){

    periodex = X/Nx;
    periodey = Y/Ny;
    halfx = periodex/2;
    halfy = periodey/2;

    tmpx1=[for (i=[0:1:Nx-1]) [[i*periodex,-d],[i*periodex,-d],[i*periodex+halfx, -d],[i*periodex+halfx,0],[i*periodex+periodex,0]]];
    tmpy1=[for (i=[0:1:Ny-1]) [[X,i*periodey],[X+d,i*periodey],[X+d,i*periodey+halfy],[X,i*periodey+halfy],[X,i*periodey+periodey]]];
    tmpx2=[for (i=[Nx:-1:1]) [[i*periodex,Y],[i*periodex,Y+d],[i*periodex-halfx, Y+d],[i*periodex-halfx,Y],[i*periodex-periodex,Y]]];
    tmpy2=[for (i=[Ny:-1:1]) [[0,i*periodey],[-d,i*periodey],[-d,i*periodey-halfy],[0,i*periodey-halfy],[0,i*periodey-periodey],[0,i*periodey-periodey]]];

    x1 = flatten(tmpx1);
    x2 = flatten(tmpx2);
    y1 = flatten(tmpy1);
    y2 = flatten(tmpy2);
    total = concat(x1,y1,x2,y2);
    polygon(total);
}

module halfcube(X, Y, Z, Nx, Ny, Nz, d){
    side(X, Y, Nx, Ny, d);
    translate([0,-Z-2*d]) 
        union(){
            side(X, Z, Nx, Nz, d);
            translate([-d,-d]) square([d,d]);
            translate([X,-d]) square([d,d]);
            translate([X,Z]) square([d,d]);
            translate([-d,Z]) square([d,d]);
        }
    translate([X+2*d,0]) side(Z, Y, Nz, Ny, d);
        
    echo ("volume box(liter):");
    echo (X*Y*Z*1e-6);
    
}

halfcube(100, 100, 100, 2, 2, 2, 9);