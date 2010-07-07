<?php

function xml_decode($contents, $get_attributes=1, $priority = 'tag') {
    if(!$contents) return array();

    if(!function_exists('xml_parser_create')) {
        //print "'xml_parser_create()' function not found!";
        return array();
    }

    //Get the XML parser of PHP - PHP must have this module for the parser to work
    $parser = xml_parser_create('');
    xml_parser_set_option($parser, XML_OPTION_TARGET_ENCODING, "UTF-8"); # http://minutillo.com/steve/weblog/2004/6/17/php-xml-and-character-encodings-a-tale-of-sadness-rage-and-data-loss
    xml_parser_set_option($parser, XML_OPTION_CASE_FOLDING, 0);
    xml_parser_set_option($parser, XML_OPTION_SKIP_WHITE, 1);
    xml_parse_into_struct($parser, trim($contents), $xml_values);
    xml_parser_free($parser);

    if(!$xml_values) return;//Hmm...

    //Initializations
    $xml_array = array();
    $parents = array();
    $opened_tags = array();
    $arr = array();

    $current = &$xml_array; //Refference

    //Go through the tags.
    $repeated_tag_index = array();//Multiple tags with same name will be turned into an array
    foreach($xml_values as $data) {
        unset($attributes,$value);//Remove existing values, or there will be trouble

        //This command will extract these variables into the foreach scope
        // tag(string), type(string), level(int), attributes(array).
        extract($data);//We could use the array by itself, but this cooler.

        $result = array();
        $attributes_data = array();
        
        if(isset($value)) {
            if($priority == 'tag') $result = $value;
            else $result['value'] = $value; //Put the value in a assoc array if we are in the 'Attribute' mode
        }

        //Set the attributes too.
        if(isset($attributes) and $get_attributes) {
            foreach($attributes as $attr => $val) {
                if($priority == 'tag') $attributes_data[$attr] = $val;
                else $result['attr'][$attr] = $val; //Set all the attributes in a array called 'attr'
            }
        }

        //See tag status and do the needed.
        if($type == "open") {//The starting of the tag '<tag>'
            $parent[$level-1] = &$current;
            if(!is_array($current) or (!in_array($tag, array_keys($current)))) { //Insert New tag
                $current[$tag] = $result;
                if($attributes_data) $current[$tag. '_attr'] = $attributes_data;
                $repeated_tag_index[$tag.'_'.$level] = 1;

                $current = &$current[$tag];

            } else { //There was another element with the same tag name

                if(isset($current[$tag][0])) {//If there is a 0th element it is already an array
                    $current[$tag][$repeated_tag_index[$tag.'_'.$level]] = $result;
                    $repeated_tag_index[$tag.'_'.$level]++;
                } else {//This section will make the value an array if multiple tags with the same name appear together
                    $current[$tag] = array($current[$tag],$result);//This will combine the existing item and the new item together to make an array
                    $repeated_tag_index[$tag.'_'.$level] = 2;
                    
                    if(isset($current[$tag.'_attr'])) { //The attribute of the last(0th) tag must be moved as well
                        $current[$tag]['0_attr'] = $current[$tag.'_attr'];
                        unset($current[$tag.'_attr']);
                    }

                }
                $last_item_index = $repeated_tag_index[$tag.'_'.$level]-1;
                $current = &$current[$tag][$last_item_index];
            }

        } elseif($type == "complete") { //Tags that ends in 1 line '<tag />'
            //See if the key is already taken.
            if(!isset($current[$tag])) { //New Key
                $current[$tag] = $result;
                $repeated_tag_index[$tag.'_'.$level] = 1;
                if($priority == 'tag' and $attributes_data) $current[$tag. '_attr'] = $attributes_data;

            } else { //If taken, put all things inside a list(array)
                if(isset($current[$tag][0]) and is_array($current[$tag])) {//If it is already an array...

                    // ...push the new element into that array.
                    $current[$tag][$repeated_tag_index[$tag.'_'.$level]] = $result;
                    
                    if($priority == 'tag' and $get_attributes and $attributes_data) {
                        $current[$tag][$repeated_tag_index[$tag.'_'.$level] . '_attr'] = $attributes_data;
                    }
                    $repeated_tag_index[$tag.'_'.$level]++;

                } else { //If it is not an array...
                    $current[$tag] = array($current[$tag],$result); //...Make it an array using using the existing value and the new value
                    $repeated_tag_index[$tag.'_'.$level] = 1;
                    if($priority == 'tag' and $get_attributes) {
                        if(isset($current[$tag.'_attr'])) { //The attribute of the last(0th) tag must be moved as well
                            
                            $current[$tag]['0_attr'] = $current[$tag.'_attr'];
                            unset($current[$tag.'_attr']);
                        }
                        
                        if($attributes_data) {
                            $current[$tag][$repeated_tag_index[$tag.'_'.$level] . '_attr'] = $attributes_data;
                        }
                    }
                    $repeated_tag_index[$tag.'_'.$level]++; //0 and 1 index is already taken
                }
            }

        } elseif($type == 'close') { //End of tag '</tag>'
            $current = &$parent[$level-1];
        }
    }
    
    return($xml_array);
}

function xml_encode($to_encode, $root = 'array', $encoding = 'UTF-8', $_level = 1, $_last_key = '')
{
	// If this is the first call, then start with a new XML tag
	
 
	// If the given content is an object, convert it to an array so that we can loop through all the values
	if (is_object($to_encode))
	{
		$to_encode = get_object_vars($to_encode);
	}
 
	if(is_string($to_encode))
	{
		$xml = "<?xml version=\"1.0\" encoding=\"{$encoding}\"?>\n<{$root}>{$to_encode}";
	}
	else
	{
		$xml = $_level == 1 ? "<?xml version=\"1.0\" encoding=\"{$encoding}\"?>\n<{$root}>\n" : '';

	// Loop through each value in the array and add it to the current level if it is a single value, or make a
	// recursive call and indent the level by one if the value contains a collection of sub values
	foreach ($to_encode as $key => $value)
	{
		$show_key = false;
		$uses_last = false;

		if (is_array($value) || is_object($value))
		{
			foreach($value as $v => $k)
				if(!is_numeric($v))
					$show_key = true;
		}

		if (is_numeric($key)) // Assume we are dealing with an index based array, so try to get a more suitable key
		{
			// Use the singular of $_last_key if it is not empty
			if ($_last_key != '')
			{
				$uses_last = true;
				$key = strtolower(trim($_last_key));
				$end = substr($key, -3);
 
				if ($end == 'ies')
				{
					$key = substr($key, 0, strlen($key) - 3).'y';
				}
				elseif ($end == 'ses')
				{
					$key = substr($key, 0, strlen($key) - 2);
				}
				else
				{
					$end = substr($key, -1);
 
					if ($end == 's')
					{
						$key = substr($key, 0, strlen($key)-1);
					}
				}
			}
			else // Otherwise just use root to avoid an error
			{
				$key = $root;
			}
		}
 
		if (is_array($value) || is_object($value))
		{
			if($show_key)
				$xml .= str_repeat("\t", $_level)."<{$key}>\n".xml_encode($value, $root, $encoding, $_level + 1, $key)
					.str_repeat("\t", $_level)."</{$key}>\n";
			else
				$xml .= str_repeat("\t", $_level).xml_encode($value, $root, $encoding, $_level + 1, $key)
					.str_repeat("\t", $_level);
		}
		else
		{
			// Trim the data since XML ignores whitespace, and convert entities to an appropriate form so that the XML
			// remains valid
			//$value = htmlentities(trim($value));

			if(stristr($value, "&") || stristr($value, "<"))
				$xml .= str_repeat("\t", $_level)."<{$key}><![CDATA[{$value}]]></{$key}>\n";
			else
				$xml .= str_repeat("\t", $_level)."<{$key}>{$value}</{$key}>\n";
		}

	}
	}
 
	// Close the XML tag if this is the last recursive call
	return $_level == 1 ? "{$xml}</{$root}>\n" : $xml;
}

?>