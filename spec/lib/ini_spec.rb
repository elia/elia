require File.dirname(__FILE__) + '/../spec_helper'
require 'ini'

INI_DATA = <<-INI
[general]\r
SequenceRepetition=100\r
BitRate=100\r
pri=5\r\n
\r\n
[packet_sequence]\r\n
TM_1=3\r\n

[TM_1]
PriOffset=0
type="CCSDS"
LogicalAddress=0x01
ProtocolID=3
VersionNumber=1
PacketType=0
DataFieldHeaderFlag=1
APID=1;ciao
;come stai
 ;molto bene
SegmentationFlags=3
SourceSequenceCounter=-1
PacketDataFieldLength=4096
PUSVersion=3
ServiceType=7
ServiceSubType=0x1E
DestinationId=5
time=-1
DataElementType=pattern
PatternFile=file_pattern.bin
INI

INI_HASH = {
  "general"=>{
    "bitrate"=>100, 
    "pri"=>5, 
    "sequencerepetition"=>100},
  "packet_sequence"=>{
    "tm_1"=>3},
  "tm_1"=>  {
    "destinationid"=>5,
    "datafieldheaderflag"=>1,
    "dataelementtype"=>"pattern",
    "apid"=>1,
    "versionnumber"=>1,
    "time"=>-1,
    "sourcesequencecounter"=>-1,
    "logicaladdress"=>1,
    "patternfile"=>"file_pattern.bin",
    "packetdatafieldlength"=>4096,
    "servicetype"=>7,
    "packettype"=>0,
    "type"=>"CCSDS",
    "prioffset"=>0,
    "servicesubtype"=>30,
    "segmentationflags"=>3,
    "pusversion"=>3,
    "protocolid"=>3}
}

describe Ini do
  it 'should parse INI files' do
    Ini.parse_ini(INI_DATA).should == INI_HASH
  end
end

