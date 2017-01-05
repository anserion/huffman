//Copyright 2017 Andrey S. Ionisyan (anserion@gmail.com)
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

//учебный шаблон создания кода Хаффмана для произвольного текста
program huffman;
const max_n=255; //максимальная длина текста (шаблон учебный :) )
type
   //описание узла дерева Хаффмана
   tsym_node=record
      status:integer; //0 - узел уже обработан, 1 - еще не обработан
      p:integer;      //количество символов в узле
      link_one,link_zero:integer; //ссылки на дочерние узлы дерева
      link_root:integer; //ссылка на родительский узел
   end;

//=================================================
var
   S:string; //входное сообщение
   A:string; //алфавит сообщения
   A_codes:array[1..max_n] of string; //двоичные коды алфавита
   n_alphabet:integer; //количество символов в алфавите
   n:integer; //количество символов входного сообщения
   a_tree:array[1..max_n] of tsym_node; //дерево Хаффмана
   //вспомогательные переменные
   i,j,i0,k,link_zero,link_one,link_root:integer;
   tmp:char;
   SS:string;
   
begin
   //ввод сообщения
   write('s='); readln(s); 
   //определение длины входного сообщения
   n:=length(s);
   writeln('n=',n);
   
   //инициализация дерева Хаффмана
   for i:=1 to max_n do
   begin
      a_tree[i].p:=0;
      a_tree[i].link_one:=0;
      a_tree[i].link_zero:=0;
      a_tree[i].link_root:=0;
      a_tree[i].status:=0;
   end;

   //сортировка символов входного текста (плохой алгоритм)
   ss:=s;
   for i:=1 to n-1 do
      for j:=i+1 to n do
         if ss[i]>ss[j] then
         begin
            tmp:=ss[i];
            ss[i]:=ss[j];
            ss[j]:=tmp;
         end;
   
   //первые листья дерева Хаффмана - это алфавит сообщения
   k:=1; i0:=1;
   A:=ss[i0];
   for i:=2 to n do
      if ss[i0]<>ss[i] then
      begin
         a_tree[k].p:=i-i0;
         i0:=i; k:=k+1; A:=A+ss[i];
      end;
   if ss[i0]=ss[n] then a_tree[k].p:=n-i0+1;
   for i:=1 to k do a_tree[i].status:=1;
   n_alphabet:=k;

   //распечатка статистики алфавита входного сообщения
   writeln('=============================');
   writeln('Alphabet statistica');
   writeln('=============================');
   for i:=1 to n_alphabet do writeln(i,': ',a[i],' - p=',a_tree[i].p);

   //формируем внутренние узлы дерева Хаффмана
   for i:=n_alphabet-1 downto 1 do
   begin
      //поиск первого узла с минимальным количеством символов
      link_zero:=1; while a_tree[link_zero].status<>1 do link_zero:=link_zero+1;
      j:=link_zero;
      while j<=k do
      begin
         if (a_tree[j].status=1)and(a_tree[j].p<=a_tree[link_zero].p) then link_zero:=j;
         j:=j+1;
      end;
      a_tree[link_zero].status:=0;
      
      //поиск второго узла с минимальным количеством символов
      link_one:=1; while a_tree[link_one].status<>1 do link_one:=link_one+1;
      j:=link_one;
      while j<=k do
      begin
         if (a_tree[j].status=1)and(a_tree[j].p<=a_tree[link_one].p) then link_one:=j;
         j:=j+1;
      end;
      a_tree[link_one].status:=0;

      //формирование нового узла-суммы минимальных узлов предыдущего слоя
      k:=k+1;
      a_tree[link_zero].link_root:=k; a_tree[link_one].link_root:=k;
      a_tree[k].link_zero:=link_zero; a_tree[k].link_one:=link_one;
      a_tree[k].p:=a_tree[link_zero].p+a_tree[link_one].p;
      a_tree[k].status:=1;
   end;

   //распечатка структуры дерева Хаффмана
   writeln('=============================');
   writeln('Huffman tree');
   writeln('=============================');
   for i:=1 to k do
      writeln(i,': p=',a_tree[i].p,
              ' to_zero=',a_tree[i].link_zero,
              ' to_one=',a_tree[i].link_one,
              ' to_root=',a_tree[i].link_root);

   //формирование двоичного кода символов алфавита
   for i:=1 to n_alphabet do
   begin
      ss:=''; j:=i;
      repeat
         link_root:=a_tree[j].link_root;
         if a_tree[link_root].link_zero=j then ss:='0'+ss else ss:='1'+ss;
         j:=link_root;
      until j=k;
      A_codes[i]:=ss;
   end;
   
   //распечатка двоичных кодов алфавита
   writeln('=============================');
   writeln('Alphabet binary codes');
   writeln('============================');
   for i:=1 to n_alphabet do writeln(i,': ',a[i],' - ',a_codes[i]);

   //подстановка кодов алфавита вместо символов сообщения
   SS:='';
   for i:=1 to n do
      for j:=1 to n_alphabet do
         if s[i]=A[j] then SS:=SS+A_codes[j];

   //распечатка итогового двоичного кода
   writeln('============================');
   writeln('Huffman code');
   writeln('============================');
   writeln(SS);
end.
