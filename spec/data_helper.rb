module DataHelper
  def data_dir
    File.join(File.dirname(__FILE__), 'support', 'binary_data')
  end

  def data_info
    binary_file1_content = IO.read(File.join(data_dir, 'test_krb5.keytab')
      ).force_encoding('ASCII-8BIT')

    binary_file2_content = IO.read(File.join(data_dir, 'random')
      ).force_encoding('ASCII-8BIT')

    data_info = {
      'Boolean' => {
        :value            => true,
        :serialized_value => '{"value":true,"metadata":{"foo":"bar","baz":42}}'
      },
      'valid UTF-8 String' =>  {
        :value            => 'some string',
        :serialized_value => '{"value":"some string","metadata":{"foo":"bar","baz":42}}'
      },
      'malformed UTF-8 String' => {
        :value            => binary_file1_content.dup.force_encoding('UTF-8'),
        :serialized_value =>
          '{"value":"' + Base64.strict_encode64(binary_file1_content) + '",' +
          '"encoding":"base64",' +
          '"original_encoding":"ASCII-8BIT",' +
          '"metadata":{"foo":"bar","baz":42}}',
        # only difference is encoding: deserialized value will have the
        # correct encoding of ASCII-8BIT
        :deserialized_value =>  binary_file1_content
      },
      'ASCII-8BIT String' => {
        :value            => binary_file2_content,
        :serialized_value =>
          '{"value":"' + Base64.strict_encode64(binary_file2_content) + '",' +
          '"encoding":"base64",' +
          '"original_encoding":"ASCII-8BIT",' +
          '"metadata":{"foo":"bar","baz":42}}'
      },
      'Integer' => {
        :value            => 255,
        :serialized_value =>  '{"value":255,"metadata":{"foo":"bar","baz":42}}'
      },
      'Float' => {
        :value            => 2.3849,
        :serialized_value => '{"value":2.3849,"metadata":{"foo":"bar","baz":42}}'
      },
      'Array of valid UTF-8 strings' => {
        :value            => [ 'valid UTF-8 1', 'valid UTF-8 2'],
        :serialized_value =>
          '{"value":["valid UTF-8 1","valid UTF-8 2"],' +
          '"metadata":{"foo":"bar","baz":42}}'
      },
      'Array of binary strings' => {
        :skip             => 'Not yet supported',
        :value            => [
           binary_file1_content.dup.force_encoding('UTF-8'),
           binary_file2_content
        ],
        :serialized_value => 'TBD'
      },
      'Hash with valid UTF-8 strings' => {
        :value => {
          'key1' => 'test_string',
          'key2' => 1000,
          'key3' => false,
          'key4' => { 'nestedkey1' => 'nested_test_string' }
        },
        :serialized_value =>
          '{"value":' +
          '{' +
          '"key1":"test_string",' +
          '"key2":1000,' +
          '"key3":false,' +
          '"key4":{"nestedkey1":"nested_test_string"}' +
          '},' +
          '"metadata":{"foo":"bar","baz":42}}'
      },
      'Hash with binary strings' => {
        :skip             => 'Not yet supported',
        :value => {
          'key1' => binary_file1_content.dup.force_encoding('UTF-8'),
          'key2' => 1000,
          'key3' => false,
          'key4' => { 'nestedkey1' => binary_file2_content }
        },
        :serialized_value => 'TBD'
      }
    }

  end
end
