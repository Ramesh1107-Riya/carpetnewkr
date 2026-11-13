select code,count(code) as codr from cacolour group by code into cursor cacol2
select code,codr from cacol2 where codr>=2