<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>PHOTO.KODAL | Image Tagger</title>
  <link href="./assets/styles.css" type="text/css" rel="stylesheet" />
  <script>
    let highlighted;
    function highlightImage(id) {
        if (highlighted) {
            document.getElementById(highlighted).classList.remove('highlight');
        }
        document.getElementById(id).classList.add('highlight');
        highlighted = id;
    }
  </script>
</head>
<body>
  <?php
    if ($_POST) {
        file_put_contents("data.json", json_encode($_POST['files']));
    }
    if (file_exists("data.json")) {
        $content = file_get_contents("data.json");
        $data = json_decode($content);   
    }
  ?>
  <form method="POST">
    <input type="submit" value="speichern" />
    <table>
        <tr>
            <th>Foto</th><th>Person(en)*</th><th>Gruppe(n)*</th>
        </tr>
        <?php 
        $files = scandir('./assets/images');
        foreach($files as $key => $file) {
            if (!in_array($file, [".", ".."] )) {
                echo "<tr>";
                echo "<td><img id='image$key' src='./assets/images/$file' onclick='highlightImage(\"image$key\");'></td>";
                echo "<td><input type='text' name='files[$file][persons]' onfocus='highlightImage(\"image$key\");' value='".($data->$file->persons ?? '')."' title='Hier bitte eintragen, wer auf dem Foto zu sehen ist.'></td>";
                echo "<td><input type='text' name='files[$file][groups]' onfocus='highlightImage(\"image$key\");' value='".($data->$file->groups ?? '')."' title='Hier bitte die Bezugsgruppe eintragen (z.B. OEB1 oder KN)'></td>";
                echo "</tr>";
            }
        } 
        ?>
        </table>
    </form>
    <p>
        * Mehrere Einträge bitte durch Kommata trennen
    </p>
</body>