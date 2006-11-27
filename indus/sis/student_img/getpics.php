<?
Header("content-type: application/x-javascript");

function returnimages($dirname=".") {
   $pattern="\.(jpg|jpeg|png|gif|bmp)$";
   $files = array();
   $curimage=0;
   if($handle = opendir($dirname)) {
       while(false !== ($file = readdir($handle))){
               if(eregi($pattern, $file)){
		 $filedate=date ("M d, Y H:i:s", filemtime($file));
                 echo 'galleryarray[' . $curimage .']=["' . $file . '", "'.$filedate.'"];' . "\n";
                 $curimage++;
               }
       }

       closedir($handle);
   }
   return($files);
}

echo "var galleryarray=new Array();" . "\n";
returnimages();
?> 
