library IEEE;
use IEEE.std_logic_1164.all;

package tipos is
    type mem32_t is array (natural range <>) of std_logic_vector (31 downto 0);
    impure function init_mem32(npalabras : positive; archivo : string) return mem32_t;
end package ;

library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;

package body tipos is
    impure function init_mem32(npalabras : positive; archivo : string) return mem32_t is
        file origen : text;
        variable origen_k : line;
        variable init : mem32_t (0 to npalabras-1) := (others=>32x"XXXXXXXX");
        variable pudo_leer : boolean := true;
    begin
        if archivo = "" then
            init := (others=>32x"0");
        else
            file_open(origen,archivo,READ_MODE);
            for k in init'range loop
                exit when endfile(origen);
                readline(origen,origen_k);
                hread(origen_k, init(k));
            end loop;
            file_close(origen);
        end if;
        return init;
    end function;
end package body;