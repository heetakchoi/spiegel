{
    package Dum;

    use strict;
    use warnings;

    use Exporter ("import");
    our @EXPORT_OK = ("jim");

    sub jim{
	return "jim";
    }

}
{
    package Dummer;
    use strict;
    use warnings;
    use Exporter ("import");
    our @EXPORT_OK = ("carry");

    sub carry{
	return "carry";
    }
}

return "Eoh::DumAndDummer";
