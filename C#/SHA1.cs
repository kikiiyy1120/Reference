//If the file should be compared
if (tmpFile.Equals("target.exe"))
{
	//Declare SHA1 class
	SHA1 mySHA1 = SHA1.Create();
	//Open FileStream
	FileStream target = File.OpenRead(ProgramPath + "target.exe");
	//Store SHA1 in byte[]
	byte[] byteTarget = mySHA1.ComputeHash(target);
	//Convert hash value to String
	string strTargetHash = GetStringFromHash(byteTarget);
	//Close FileStream
	target.Close();

	//Open StreamReader
	StreamReader hashValue = new StreamReader(ProgramPath + "hash_values.bb");
	//Declare variable to store saved SHA1 hash value
	string strHash = string.Empty;

	for (int i = 0; i < 8; i++)
	{
		//SHA1 hash value is on line 8
		if (i == 7)
			//Store hash value
			strHash = hashValue.ReadLine();
		else
			hashValue.ReadLine();
	}
	//Close StreamReader
	hashValue.Close();

	//Compare target.exe hash value to hash_value.bb hash value
	if (!strTargetHash.Equals(strHash))
	{
		//If the comparison is incorrect, Show message
		MessageBox.Show("The target.exe file is not copied because of an integrity check failure.");
		//Delete file compared
		File.Delete(ProgramPath + "target.exe");
	}
}

private static string GetStringFromHash(byte[] hash)
{
	StringBuilder result = new StringBuilder();
	for (int i = 0; i < hash.Length; i++)
	{
		//byte[] to hexadecimal
		result.Append(hash[i].ToString("X2"));
	}
	return result.ToString();
}
