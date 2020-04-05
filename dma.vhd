----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:24:39 04/05/2020 
-- Design Name: 
-- Module Name:    dma - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dma is
    Port ( IOR : inout  STD_LOGIC;
           IOW : inout  STD_LOGIC;
           MEMR : out  STD_LOGIC;
           MEMW : out  STD_LOGIC;
           HLDA : in  STD_LOGIC;
           AEN : out  STD_LOGIC;
           HRQ : out  STD_LOGIC;
           CS : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           DRQ : in  STD_LOGIC_VECTOR (3 downto 0);
           DACK : out  STD_LOGIC_VECTOR (3 downto 0);
           D : inout  STD_LOGIC_VECTOR (7 downto 0);
           A : inout  STD_LOGIC_VECTOR (7 downto 0);
           clk : in  STD_LOGIC);
end dma;

architecture Behavioral of dma is
signal data : STD_LOGIC_VECTOR(7 downto 0) :="00000000";
signal addr : STD_LOGIC_VECTOR(7 downto 0) :="00000000";

begin
process (clk,RESET,DRQ,HLDA,CS,A,D,IOR,IOW)
variable x : integer :=0;

begin 

x:=5;
if (RESET='1') then
    A<="00000000";
    D<="00000000";
elsif (RESET='0') then
    for i in 0 to 3 loop
	     if (DRQ(i)='1') then 
	     x:=i;
	     end if;
	 end loop;
	 if (x/=5) then
	     HRQ<='1';
		  if (HLDA='1') then
		      AEN<='1';
		      DACK(x)<='1';
				--if(clk'event and clk='1') then
				if (IOR='0' and IOW='1') then
				    
				        MEMR<='0';
					     MEMW<='1';  --reading memory active LOW
					     for i in 0 to 7 loop
					         addr(i)<=A(i);
					         data(i)<=D(i);
					     end loop;
					     MEMR<='1';
					     MEMW<='1';
					-- end if;
					 IOR<='1';
					 IOW<='0';
					 --if(clk'event and clk='1') then
					     for i in 0 to 7 loop
					         A(i)<=addr(i);
					         D(i)<=data(i);
					     end loop;
						  IOR<='1';
						  IOW<='1';
				    --end if;
				end if;
				if (IOR='1' and IOW='0') then
				    --if(clk'event and clk='1') then
					     for i in 0 to 7 loop
					         addr(i)<=A(i);
					         data(i)<=D(i);
						  end loop;
					 --end if;
					-- if(clk'event and clk='1') then
					     MEMR<='1';
					     MEMW<='0';    --writing in memory active LOW
						  for i in 0 to 7 loop
					         A(i)<=addr(i);
					         D(i)<=data(i);
					     end loop;
                    MEMR<='1';
					     MEMW<='1';
				-- end if; 
            end if;
			end if;
     end if;
end if;
end process;	   
end Behavioral;

