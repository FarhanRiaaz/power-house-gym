// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_client.dart';

// ignore_for_file: type=lint
class $MembersTable extends Members with TableInfo<$MembersTable, Member> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<int> memberId = GeneratedColumn<int>(
    'member_id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 15,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatherNameMeta = const VerificationMeta(
    'fatherName',
  );
  @override
  late final GeneratedColumn<String> fatherName = GeneratedColumn<String>(
    'father_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Gender, String> gender =
      GeneratedColumn<String>(
        'gender',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Gender>($MembersTable.$convertergender);
  @override
  late final GeneratedColumnWithTypeConverter<MemberShipType, String>
  membershipType = GeneratedColumn<String>(
    'membership_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<MemberShipType>($MembersTable.$convertermembershipType);
  static const VerificationMeta _registrationDateMeta = const VerificationMeta(
    'registrationDate',
  );
  @override
  late final GeneratedColumn<DateTime> registrationDate =
      GeneratedColumn<DateTime>(
        'registration_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _lastFeePaymentDateMeta =
      const VerificationMeta('lastFeePaymentDate');
  @override
  late final GeneratedColumn<DateTime> lastFeePaymentDate =
      GeneratedColumn<DateTime>(
        'last_fee_payment_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _fingerprintTemplateMeta =
      const VerificationMeta('fingerprintTemplate');
  @override
  late final GeneratedColumn<String> fingerprintTemplate =
      GeneratedColumn<String>(
        'fingerprint_template',
        aliasedName,
        false,
        additionalChecks: GeneratedColumn.checkTextLength(
          minTextLength: 1,
          maxTextLength: 6000,
        ),
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    memberId,
    name,
    phoneNumber,
    fatherName,
    gender,
    membershipType,
    registrationDate,
    lastFeePaymentDate,
    fingerprintTemplate,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members';
  @override
  VerificationContext validateIntegrity(
    Insertable<Member> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('father_name')) {
      context.handle(
        _fatherNameMeta,
        fatherName.isAcceptableOrUnknown(data['father_name']!, _fatherNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fatherNameMeta);
    }
    if (data.containsKey('registration_date')) {
      context.handle(
        _registrationDateMeta,
        registrationDate.isAcceptableOrUnknown(
          data['registration_date']!,
          _registrationDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_registrationDateMeta);
    }
    if (data.containsKey('last_fee_payment_date')) {
      context.handle(
        _lastFeePaymentDateMeta,
        lastFeePaymentDate.isAcceptableOrUnknown(
          data['last_fee_payment_date']!,
          _lastFeePaymentDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastFeePaymentDateMeta);
    }
    if (data.containsKey('fingerprint_template')) {
      context.handle(
        _fingerprintTemplateMeta,
        fingerprintTemplate.isAcceptableOrUnknown(
          data['fingerprint_template']!,
          _fingerprintTemplateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fingerprintTemplateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {memberId};
  @override
  Member map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Member(
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      fatherName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}father_name'],
      )!,
      gender: $MembersTable.$convertergender.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}gender'],
        )!,
      ),
      membershipType: $MembersTable.$convertermembershipType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}membership_type'],
        )!,
      ),
      registrationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}registration_date'],
      )!,
      lastFeePaymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_fee_payment_date'],
      )!,
      fingerprintTemplate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fingerprint_template'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Gender, String, String> $convertergender =
      const EnumNameConverter<Gender>(Gender.values);
  static JsonTypeConverter2<MemberShipType, String, String>
  $convertermembershipType = const EnumNameConverter<MemberShipType>(
    MemberShipType.values,
  );
}

class Member extends DataClass implements Insertable<Member> {
  final int memberId;
  final String name;
  final String phoneNumber;
  final String fatherName;
  final Gender gender;
  final MemberShipType membershipType;
  final DateTime registrationDate;
  final DateTime lastFeePaymentDate;
  final String fingerprintTemplate;
  final String? notes;
  const Member({
    required this.memberId,
    required this.name,
    required this.phoneNumber,
    required this.fatherName,
    required this.gender,
    required this.membershipType,
    required this.registrationDate,
    required this.lastFeePaymentDate,
    required this.fingerprintTemplate,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['member_id'] = Variable<int>(memberId);
    map['name'] = Variable<String>(name);
    map['phone_number'] = Variable<String>(phoneNumber);
    map['father_name'] = Variable<String>(fatherName);
    {
      map['gender'] = Variable<String>(
        $MembersTable.$convertergender.toSql(gender),
      );
    }
    {
      map['membership_type'] = Variable<String>(
        $MembersTable.$convertermembershipType.toSql(membershipType),
      );
    }
    map['registration_date'] = Variable<DateTime>(registrationDate);
    map['last_fee_payment_date'] = Variable<DateTime>(lastFeePaymentDate);
    map['fingerprint_template'] = Variable<String>(fingerprintTemplate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  MembersCompanion toCompanion(bool nullToAbsent) {
    return MembersCompanion(
      memberId: Value(memberId),
      name: Value(name),
      phoneNumber: Value(phoneNumber),
      fatherName: Value(fatherName),
      gender: Value(gender),
      membershipType: Value(membershipType),
      registrationDate: Value(registrationDate),
      lastFeePaymentDate: Value(lastFeePaymentDate),
      fingerprintTemplate: Value(fingerprintTemplate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Member.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Member(
      memberId: serializer.fromJson<int>(json['memberId']),
      name: serializer.fromJson<String>(json['name']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      fatherName: serializer.fromJson<String>(json['fatherName']),
      gender: $MembersTable.$convertergender.fromJson(
        serializer.fromJson<String>(json['gender']),
      ),
      membershipType: $MembersTable.$convertermembershipType.fromJson(
        serializer.fromJson<String>(json['membershipType']),
      ),
      registrationDate: serializer.fromJson<DateTime>(json['registrationDate']),
      lastFeePaymentDate: serializer.fromJson<DateTime>(
        json['lastFeePaymentDate'],
      ),
      fingerprintTemplate: serializer.fromJson<String>(
        json['fingerprintTemplate'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'memberId': serializer.toJson<int>(memberId),
      'name': serializer.toJson<String>(name),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'fatherName': serializer.toJson<String>(fatherName),
      'gender': serializer.toJson<String>(
        $MembersTable.$convertergender.toJson(gender),
      ),
      'membershipType': serializer.toJson<String>(
        $MembersTable.$convertermembershipType.toJson(membershipType),
      ),
      'registrationDate': serializer.toJson<DateTime>(registrationDate),
      'lastFeePaymentDate': serializer.toJson<DateTime>(lastFeePaymentDate),
      'fingerprintTemplate': serializer.toJson<String>(fingerprintTemplate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Member copyWith({
    int? memberId,
    String? name,
    String? phoneNumber,
    String? fatherName,
    Gender? gender,
    MemberShipType? membershipType,
    DateTime? registrationDate,
    DateTime? lastFeePaymentDate,
    String? fingerprintTemplate,
    Value<String?> notes = const Value.absent(),
  }) => Member(
    memberId: memberId ?? this.memberId,
    name: name ?? this.name,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    fatherName: fatherName ?? this.fatherName,
    gender: gender ?? this.gender,
    membershipType: membershipType ?? this.membershipType,
    registrationDate: registrationDate ?? this.registrationDate,
    lastFeePaymentDate: lastFeePaymentDate ?? this.lastFeePaymentDate,
    fingerprintTemplate: fingerprintTemplate ?? this.fingerprintTemplate,
    notes: notes.present ? notes.value : this.notes,
  );
  Member copyWithCompanion(MembersCompanion data) {
    return Member(
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      name: data.name.present ? data.name.value : this.name,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      fatherName: data.fatherName.present
          ? data.fatherName.value
          : this.fatherName,
      gender: data.gender.present ? data.gender.value : this.gender,
      membershipType: data.membershipType.present
          ? data.membershipType.value
          : this.membershipType,
      registrationDate: data.registrationDate.present
          ? data.registrationDate.value
          : this.registrationDate,
      lastFeePaymentDate: data.lastFeePaymentDate.present
          ? data.lastFeePaymentDate.value
          : this.lastFeePaymentDate,
      fingerprintTemplate: data.fingerprintTemplate.present
          ? data.fingerprintTemplate.value
          : this.fingerprintTemplate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Member(')
          ..write('memberId: $memberId, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('fatherName: $fatherName, ')
          ..write('gender: $gender, ')
          ..write('membershipType: $membershipType, ')
          ..write('registrationDate: $registrationDate, ')
          ..write('lastFeePaymentDate: $lastFeePaymentDate, ')
          ..write('fingerprintTemplate: $fingerprintTemplate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    memberId,
    name,
    phoneNumber,
    fatherName,
    gender,
    membershipType,
    registrationDate,
    lastFeePaymentDate,
    fingerprintTemplate,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Member &&
          other.memberId == this.memberId &&
          other.name == this.name &&
          other.phoneNumber == this.phoneNumber &&
          other.fatherName == this.fatherName &&
          other.gender == this.gender &&
          other.membershipType == this.membershipType &&
          other.registrationDate == this.registrationDate &&
          other.lastFeePaymentDate == this.lastFeePaymentDate &&
          other.fingerprintTemplate == this.fingerprintTemplate &&
          other.notes == this.notes);
}

class MembersCompanion extends UpdateCompanion<Member> {
  final Value<int> memberId;
  final Value<String> name;
  final Value<String> phoneNumber;
  final Value<String> fatherName;
  final Value<Gender> gender;
  final Value<MemberShipType> membershipType;
  final Value<DateTime> registrationDate;
  final Value<DateTime> lastFeePaymentDate;
  final Value<String> fingerprintTemplate;
  final Value<String?> notes;
  const MembersCompanion({
    this.memberId = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.fatherName = const Value.absent(),
    this.gender = const Value.absent(),
    this.membershipType = const Value.absent(),
    this.registrationDate = const Value.absent(),
    this.lastFeePaymentDate = const Value.absent(),
    this.fingerprintTemplate = const Value.absent(),
    this.notes = const Value.absent(),
  });
  MembersCompanion.insert({
    this.memberId = const Value.absent(),
    required String name,
    required String phoneNumber,
    required String fatherName,
    required Gender gender,
    required MemberShipType membershipType,
    required DateTime registrationDate,
    required DateTime lastFeePaymentDate,
    required String fingerprintTemplate,
    this.notes = const Value.absent(),
  }) : name = Value(name),
       phoneNumber = Value(phoneNumber),
       fatherName = Value(fatherName),
       gender = Value(gender),
       membershipType = Value(membershipType),
       registrationDate = Value(registrationDate),
       lastFeePaymentDate = Value(lastFeePaymentDate),
       fingerprintTemplate = Value(fingerprintTemplate);
  static Insertable<Member> custom({
    Expression<int>? memberId,
    Expression<String>? name,
    Expression<String>? phoneNumber,
    Expression<String>? fatherName,
    Expression<String>? gender,
    Expression<String>? membershipType,
    Expression<DateTime>? registrationDate,
    Expression<DateTime>? lastFeePaymentDate,
    Expression<String>? fingerprintTemplate,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (memberId != null) 'member_id': memberId,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (fatherName != null) 'father_name': fatherName,
      if (gender != null) 'gender': gender,
      if (membershipType != null) 'membership_type': membershipType,
      if (registrationDate != null) 'registration_date': registrationDate,
      if (lastFeePaymentDate != null)
        'last_fee_payment_date': lastFeePaymentDate,
      if (fingerprintTemplate != null)
        'fingerprint_template': fingerprintTemplate,
      if (notes != null) 'notes': notes,
    });
  }

  MembersCompanion copyWith({
    Value<int>? memberId,
    Value<String>? name,
    Value<String>? phoneNumber,
    Value<String>? fatherName,
    Value<Gender>? gender,
    Value<MemberShipType>? membershipType,
    Value<DateTime>? registrationDate,
    Value<DateTime>? lastFeePaymentDate,
    Value<String>? fingerprintTemplate,
    Value<String?>? notes,
  }) {
    return MembersCompanion(
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fatherName: fatherName ?? this.fatherName,
      gender: gender ?? this.gender,
      membershipType: membershipType ?? this.membershipType,
      registrationDate: registrationDate ?? this.registrationDate,
      lastFeePaymentDate: lastFeePaymentDate ?? this.lastFeePaymentDate,
      fingerprintTemplate: fingerprintTemplate ?? this.fingerprintTemplate,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (memberId.present) {
      map['member_id'] = Variable<int>(memberId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (fatherName.present) {
      map['father_name'] = Variable<String>(fatherName.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(
        $MembersTable.$convertergender.toSql(gender.value),
      );
    }
    if (membershipType.present) {
      map['membership_type'] = Variable<String>(
        $MembersTable.$convertermembershipType.toSql(membershipType.value),
      );
    }
    if (registrationDate.present) {
      map['registration_date'] = Variable<DateTime>(registrationDate.value);
    }
    if (lastFeePaymentDate.present) {
      map['last_fee_payment_date'] = Variable<DateTime>(
        lastFeePaymentDate.value,
      );
    }
    if (fingerprintTemplate.present) {
      map['fingerprint_template'] = Variable<String>(fingerprintTemplate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('memberId: $memberId, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('fatherName: $fatherName, ')
          ..write('gender: $gender, ')
          ..write('membershipType: $membershipType, ')
          ..write('registrationDate: $registrationDate, ')
          ..write('lastFeePaymentDate: $lastFeePaymentDate, ')
          ..write('fingerprintTemplate: $fingerprintTemplate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $BillExpensesTable extends BillExpenses
    with TableInfo<$BillExpensesTable, BillExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    amount,
    date,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillExpense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillExpense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $BillExpensesTable createAlias(String alias) {
    return $BillExpensesTable(attachedDatabase, alias);
  }
}

class BillExpense extends DataClass implements Insertable<BillExpense> {
  final int id;
  final String category;
  final double amount;
  final DateTime date;
  final String description;
  const BillExpense({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['description'] = Variable<String>(description);
    return map;
  }

  BillExpensesCompanion toCompanion(bool nullToAbsent) {
    return BillExpensesCompanion(
      id: Value(id),
      category: Value(category),
      amount: Value(amount),
      date: Value(date),
      description: Value(description),
    );
  }

  factory BillExpense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillExpense(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'description': serializer.toJson<String>(description),
    };
  }

  BillExpense copyWith({
    int? id,
    String? category,
    double? amount,
    DateTime? date,
    String? description,
  }) => BillExpense(
    id: id ?? this.id,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    description: description ?? this.description,
  );
  BillExpense copyWithCompanion(BillExpensesCompanion data) {
    return BillExpense(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillExpense(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, amount, date, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillExpense &&
          other.id == this.id &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.description == this.description);
}

class BillExpensesCompanion extends UpdateCompanion<BillExpense> {
  final Value<int> id;
  final Value<String> category;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> description;
  const BillExpensesCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
  });
  BillExpensesCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required double amount,
    required DateTime date,
    required String description,
  }) : category = Value(category),
       amount = Value(amount),
       date = Value(date),
       description = Value(description);
  static Insertable<BillExpense> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
    });
  }

  BillExpensesCompanion copyWith({
    Value<int>? id,
    Value<String>? category,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<String>? description,
  }) {
    return BillExpensesCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillExpensesCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $FinancialTransactionsTable extends FinancialTransactions
    with TableInfo<$FinancialTransactionsTable, FinancialTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatedMemberIdMeta = const VerificationMeta(
    'relatedMemberId',
  );
  @override
  late final GeneratedColumn<int> relatedMemberId = GeneratedColumn<int>(
    'related_member_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (member_id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    amount,
    transactionDate,
    description,
    relatedMemberId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinancialTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('related_member_id')) {
      context.handle(
        _relatedMemberIdMeta,
        relatedMemberId.isAcceptableOrUnknown(
          data['related_member_id']!,
          _relatedMemberIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialTransaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      relatedMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}related_member_id'],
      ),
    );
  }

  @override
  $FinancialTransactionsTable createAlias(String alias) {
    return $FinancialTransactionsTable(attachedDatabase, alias);
  }
}

class FinancialTransaction extends DataClass
    implements Insertable<FinancialTransaction> {
  final int id;
  final String type;
  final double amount;
  final DateTime transactionDate;
  final String description;
  final int? relatedMemberId;
  const FinancialTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.transactionDate,
    required this.description,
    this.relatedMemberId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || relatedMemberId != null) {
      map['related_member_id'] = Variable<int>(relatedMemberId);
    }
    return map;
  }

  FinancialTransactionsCompanion toCompanion(bool nullToAbsent) {
    return FinancialTransactionsCompanion(
      id: Value(id),
      type: Value(type),
      amount: Value(amount),
      transactionDate: Value(transactionDate),
      description: Value(description),
      relatedMemberId: relatedMemberId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedMemberId),
    );
  }

  factory FinancialTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialTransaction(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      description: serializer.fromJson<String>(json['description']),
      relatedMemberId: serializer.fromJson<int?>(json['relatedMemberId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'description': serializer.toJson<String>(description),
      'relatedMemberId': serializer.toJson<int?>(relatedMemberId),
    };
  }

  FinancialTransaction copyWith({
    int? id,
    String? type,
    double? amount,
    DateTime? transactionDate,
    String? description,
    Value<int?> relatedMemberId = const Value.absent(),
  }) => FinancialTransaction(
    id: id ?? this.id,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    transactionDate: transactionDate ?? this.transactionDate,
    description: description ?? this.description,
    relatedMemberId: relatedMemberId.present
        ? relatedMemberId.value
        : this.relatedMemberId,
  );
  FinancialTransaction copyWithCompanion(FinancialTransactionsCompanion data) {
    return FinancialTransaction(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      description: data.description.present
          ? data.description.value
          : this.description,
      relatedMemberId: data.relatedMemberId.present
          ? data.relatedMemberId.value
          : this.relatedMemberId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialTransaction(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('description: $description, ')
          ..write('relatedMemberId: $relatedMemberId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    amount,
    transactionDate,
    description,
    relatedMemberId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialTransaction &&
          other.id == this.id &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.transactionDate == this.transactionDate &&
          other.description == this.description &&
          other.relatedMemberId == this.relatedMemberId);
}

class FinancialTransactionsCompanion
    extends UpdateCompanion<FinancialTransaction> {
  final Value<int> id;
  final Value<String> type;
  final Value<double> amount;
  final Value<DateTime> transactionDate;
  final Value<String> description;
  final Value<int?> relatedMemberId;
  const FinancialTransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.description = const Value.absent(),
    this.relatedMemberId = const Value.absent(),
  });
  FinancialTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required double amount,
    required DateTime transactionDate,
    required String description,
    this.relatedMemberId = const Value.absent(),
  }) : type = Value(type),
       amount = Value(amount),
       transactionDate = Value(transactionDate),
       description = Value(description);
  static Insertable<FinancialTransaction> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<DateTime>? transactionDate,
    Expression<String>? description,
    Expression<int>? relatedMemberId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (description != null) 'description': description,
      if (relatedMemberId != null) 'related_member_id': relatedMemberId,
    });
  }

  FinancialTransactionsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<double>? amount,
    Value<DateTime>? transactionDate,
    Value<String>? description,
    Value<int?>? relatedMemberId,
  }) {
    return FinancialTransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      transactionDate: transactionDate ?? this.transactionDate,
      description: description ?? this.description,
      relatedMemberId: relatedMemberId ?? this.relatedMemberId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (relatedMemberId.present) {
      map['related_member_id'] = Variable<int>(relatedMemberId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('description: $description, ')
          ..write('relatedMemberId: $relatedMemberId')
          ..write(')'))
        .toString();
  }
}

class $AttendanceRecordsTable extends AttendanceRecords
    with TableInfo<$AttendanceRecordsTable, AttendanceRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<int> memberId = GeneratedColumn<int>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES members (member_id)',
    ),
  );
  static const VerificationMeta _checkInTimeMeta = const VerificationMeta(
    'checkInTime',
  );
  @override
  late final GeneratedColumn<DateTime> checkInTime = GeneratedColumn<DateTime>(
    'check_in_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, memberId, checkInTime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('check_in_time')) {
      context.handle(
        _checkInTimeMeta,
        checkInTime.isAcceptableOrUnknown(
          data['check_in_time']!,
          _checkInTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checkInTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AttendanceRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_id'],
      )!,
      checkInTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check_in_time'],
      )!,
    );
  }

  @override
  $AttendanceRecordsTable createAlias(String alias) {
    return $AttendanceRecordsTable(attachedDatabase, alias);
  }
}

class AttendanceRecord extends DataClass
    implements Insertable<AttendanceRecord> {
  final int id;
  final int memberId;
  final DateTime checkInTime;
  const AttendanceRecord({
    required this.id,
    required this.memberId,
    required this.checkInTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['member_id'] = Variable<int>(memberId);
    map['check_in_time'] = Variable<DateTime>(checkInTime);
    return map;
  }

  AttendanceRecordsCompanion toCompanion(bool nullToAbsent) {
    return AttendanceRecordsCompanion(
      id: Value(id),
      memberId: Value(memberId),
      checkInTime: Value(checkInTime),
    );
  }

  factory AttendanceRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceRecord(
      id: serializer.fromJson<int>(json['id']),
      memberId: serializer.fromJson<int>(json['memberId']),
      checkInTime: serializer.fromJson<DateTime>(json['checkInTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'memberId': serializer.toJson<int>(memberId),
      'checkInTime': serializer.toJson<DateTime>(checkInTime),
    };
  }

  AttendanceRecord copyWith({int? id, int? memberId, DateTime? checkInTime}) =>
      AttendanceRecord(
        id: id ?? this.id,
        memberId: memberId ?? this.memberId,
        checkInTime: checkInTime ?? this.checkInTime,
      );
  AttendanceRecord copyWithCompanion(AttendanceRecordsCompanion data) {
    return AttendanceRecord(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      checkInTime: data.checkInTime.present
          ? data.checkInTime.value
          : this.checkInTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRecord(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('checkInTime: $checkInTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, memberId, checkInTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceRecord &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.checkInTime == this.checkInTime);
}

class AttendanceRecordsCompanion extends UpdateCompanion<AttendanceRecord> {
  final Value<int> id;
  final Value<int> memberId;
  final Value<DateTime> checkInTime;
  const AttendanceRecordsCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.checkInTime = const Value.absent(),
  });
  AttendanceRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int memberId,
    required DateTime checkInTime,
  }) : memberId = Value(memberId),
       checkInTime = Value(checkInTime);
  static Insertable<AttendanceRecord> custom({
    Expression<int>? id,
    Expression<int>? memberId,
    Expression<DateTime>? checkInTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (checkInTime != null) 'check_in_time': checkInTime,
    });
  }

  AttendanceRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? memberId,
    Value<DateTime>? checkInTime,
  }) {
    return AttendanceRecordsCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      checkInTime: checkInTime ?? this.checkInTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<int>(memberId.value);
    }
    if (checkInTime.present) {
      map['check_in_time'] = Variable<DateTime>(checkInTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRecordsCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('checkInTime: $checkInTime')
          ..write(')'))
        .toString();
  }
}

abstract class _$DriftClient extends GeneratedDatabase {
  _$DriftClient(QueryExecutor e) : super(e);
  $DriftClientManager get managers => $DriftClientManager(this);
  late final $MembersTable members = $MembersTable(this);
  late final $BillExpensesTable billExpenses = $BillExpensesTable(this);
  late final $FinancialTransactionsTable financialTransactions =
      $FinancialTransactionsTable(this);
  late final $AttendanceRecordsTable attendanceRecords =
      $AttendanceRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    members,
    billExpenses,
    financialTransactions,
    attendanceRecords,
  ];
}

typedef $$MembersTableCreateCompanionBuilder =
    MembersCompanion Function({
      Value<int> memberId,
      required String name,
      required String phoneNumber,
      required String fatherName,
      required Gender gender,
      required MemberShipType membershipType,
      required DateTime registrationDate,
      required DateTime lastFeePaymentDate,
      required String fingerprintTemplate,
      Value<String?> notes,
    });
typedef $$MembersTableUpdateCompanionBuilder =
    MembersCompanion Function({
      Value<int> memberId,
      Value<String> name,
      Value<String> phoneNumber,
      Value<String> fatherName,
      Value<Gender> gender,
      Value<MemberShipType> membershipType,
      Value<DateTime> registrationDate,
      Value<DateTime> lastFeePaymentDate,
      Value<String> fingerprintTemplate,
      Value<String?> notes,
    });

final class $$MembersTableReferences
    extends BaseReferences<_$DriftClient, $MembersTable, Member> {
  $$MembersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $FinancialTransactionsTable,
    List<FinancialTransaction>
  >
  _financialTransactionsRefsTable(_$DriftClient db) =>
      MultiTypedResultKey.fromTable(
        db.financialTransactions,
        aliasName: $_aliasNameGenerator(
          db.members.memberId,
          db.financialTransactions.relatedMemberId,
        ),
      );

  $$FinancialTransactionsTableProcessedTableManager
  get financialTransactionsRefs {
    final manager =
        $$FinancialTransactionsTableTableManager(
          $_db,
          $_db.financialTransactions,
        ).filter(
          (f) => f.relatedMemberId.memberId.sqlEquals(
            $_itemColumn<int>('member_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _financialTransactionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AttendanceRecordsTable, List<AttendanceRecord>>
  _attendanceRecordsRefsTable(_$DriftClient db) =>
      MultiTypedResultKey.fromTable(
        db.attendanceRecords,
        aliasName: $_aliasNameGenerator(
          db.members.memberId,
          db.attendanceRecords.memberId,
        ),
      );

  $$AttendanceRecordsTableProcessedTableManager get attendanceRecordsRefs {
    final manager =
        $$AttendanceRecordsTableTableManager(
          $_db,
          $_db.attendanceRecords,
        ).filter(
          (f) => f.memberId.memberId.sqlEquals($_itemColumn<int>('member_id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _attendanceRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MembersTableFilterComposer
    extends Composer<_$DriftClient, $MembersTable> {
  $$MembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fatherName => $composableBuilder(
    column: $table.fatherName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Gender, Gender, String> get gender =>
      $composableBuilder(
        column: $table.gender,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<MemberShipType, MemberShipType, String>
  get membershipType => $composableBuilder(
    column: $table.membershipType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastFeePaymentDate => $composableBuilder(
    column: $table.lastFeePaymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fingerprintTemplate => $composableBuilder(
    column: $table.fingerprintTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> financialTransactionsRefs(
    Expression<bool> Function($$FinancialTransactionsTableFilterComposer f) f,
  ) {
    final $$FinancialTransactionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.memberId,
          referencedTable: $db.financialTransactions,
          getReferencedColumn: (t) => t.relatedMemberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialTransactionsTableFilterComposer(
                $db: $db,
                $table: $db.financialTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> attendanceRecordsRefs(
    Expression<bool> Function($$AttendanceRecordsTableFilterComposer f) f,
  ) {
    final $$AttendanceRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.attendanceRecords,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceRecordsTableFilterComposer(
            $db: $db,
            $table: $db.attendanceRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MembersTableOrderingComposer
    extends Composer<_$DriftClient, $MembersTable> {
  $$MembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fatherName => $composableBuilder(
    column: $table.fatherName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get membershipType => $composableBuilder(
    column: $table.membershipType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastFeePaymentDate => $composableBuilder(
    column: $table.lastFeePaymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fingerprintTemplate => $composableBuilder(
    column: $table.fingerprintTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MembersTableAnnotationComposer
    extends Composer<_$DriftClient, $MembersTable> {
  $$MembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fatherName => $composableBuilder(
    column: $table.fatherName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Gender, String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MemberShipType, String> get membershipType =>
      $composableBuilder(
        column: $table.membershipType,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get registrationDate => $composableBuilder(
    column: $table.registrationDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastFeePaymentDate => $composableBuilder(
    column: $table.lastFeePaymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fingerprintTemplate => $composableBuilder(
    column: $table.fingerprintTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> financialTransactionsRefs<T extends Object>(
    Expression<T> Function($$FinancialTransactionsTableAnnotationComposer a) f,
  ) {
    final $$FinancialTransactionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.memberId,
          referencedTable: $db.financialTransactions,
          getReferencedColumn: (t) => t.relatedMemberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialTransactionsTableAnnotationComposer(
                $db: $db,
                $table: $db.financialTransactions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> attendanceRecordsRefs<T extends Object>(
    Expression<T> Function($$AttendanceRecordsTableAnnotationComposer a) f,
  ) {
    final $$AttendanceRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.memberId,
          referencedTable: $db.attendanceRecords,
          getReferencedColumn: (t) => t.memberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AttendanceRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.attendanceRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$MembersTableTableManager
    extends
        RootTableManager<
          _$DriftClient,
          $MembersTable,
          Member,
          $$MembersTableFilterComposer,
          $$MembersTableOrderingComposer,
          $$MembersTableAnnotationComposer,
          $$MembersTableCreateCompanionBuilder,
          $$MembersTableUpdateCompanionBuilder,
          (Member, $$MembersTableReferences),
          Member,
          PrefetchHooks Function({
            bool financialTransactionsRefs,
            bool attendanceRecordsRefs,
          })
        > {
  $$MembersTableTableManager(_$DriftClient db, $MembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> memberId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String> fatherName = const Value.absent(),
                Value<Gender> gender = const Value.absent(),
                Value<MemberShipType> membershipType = const Value.absent(),
                Value<DateTime> registrationDate = const Value.absent(),
                Value<DateTime> lastFeePaymentDate = const Value.absent(),
                Value<String> fingerprintTemplate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => MembersCompanion(
                memberId: memberId,
                name: name,
                phoneNumber: phoneNumber,
                fatherName: fatherName,
                gender: gender,
                membershipType: membershipType,
                registrationDate: registrationDate,
                lastFeePaymentDate: lastFeePaymentDate,
                fingerprintTemplate: fingerprintTemplate,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> memberId = const Value.absent(),
                required String name,
                required String phoneNumber,
                required String fatherName,
                required Gender gender,
                required MemberShipType membershipType,
                required DateTime registrationDate,
                required DateTime lastFeePaymentDate,
                required String fingerprintTemplate,
                Value<String?> notes = const Value.absent(),
              }) => MembersCompanion.insert(
                memberId: memberId,
                name: name,
                phoneNumber: phoneNumber,
                fatherName: fatherName,
                gender: gender,
                membershipType: membershipType,
                registrationDate: registrationDate,
                lastFeePaymentDate: lastFeePaymentDate,
                fingerprintTemplate: fingerprintTemplate,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                financialTransactionsRefs = false,
                attendanceRecordsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (financialTransactionsRefs) db.financialTransactions,
                    if (attendanceRecordsRefs) db.attendanceRecords,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (financialTransactionsRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          FinancialTransaction
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._financialTransactionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).financialTransactionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.relatedMemberId == item.memberId,
                              ),
                          typedResults: items,
                        ),
                      if (attendanceRecordsRefs)
                        await $_getPrefetchedData<
                          Member,
                          $MembersTable,
                          AttendanceRecord
                        >(
                          currentTable: table,
                          referencedTable: $$MembersTableReferences
                              ._attendanceRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MembersTableReferences(
                                db,
                                table,
                                p0,
                              ).attendanceRecordsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.memberId == item.memberId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MembersTableProcessedTableManager =
    ProcessedTableManager<
      _$DriftClient,
      $MembersTable,
      Member,
      $$MembersTableFilterComposer,
      $$MembersTableOrderingComposer,
      $$MembersTableAnnotationComposer,
      $$MembersTableCreateCompanionBuilder,
      $$MembersTableUpdateCompanionBuilder,
      (Member, $$MembersTableReferences),
      Member,
      PrefetchHooks Function({
        bool financialTransactionsRefs,
        bool attendanceRecordsRefs,
      })
    >;
typedef $$BillExpensesTableCreateCompanionBuilder =
    BillExpensesCompanion Function({
      Value<int> id,
      required String category,
      required double amount,
      required DateTime date,
      required String description,
    });
typedef $$BillExpensesTableUpdateCompanionBuilder =
    BillExpensesCompanion Function({
      Value<int> id,
      Value<String> category,
      Value<double> amount,
      Value<DateTime> date,
      Value<String> description,
    });

class $$BillExpensesTableFilterComposer
    extends Composer<_$DriftClient, $BillExpensesTable> {
  $$BillExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BillExpensesTableOrderingComposer
    extends Composer<_$DriftClient, $BillExpensesTable> {
  $$BillExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BillExpensesTableAnnotationComposer
    extends Composer<_$DriftClient, $BillExpensesTable> {
  $$BillExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );
}

class $$BillExpensesTableTableManager
    extends
        RootTableManager<
          _$DriftClient,
          $BillExpensesTable,
          BillExpense,
          $$BillExpensesTableFilterComposer,
          $$BillExpensesTableOrderingComposer,
          $$BillExpensesTableAnnotationComposer,
          $$BillExpensesTableCreateCompanionBuilder,
          $$BillExpensesTableUpdateCompanionBuilder,
          (
            BillExpense,
            BaseReferences<_$DriftClient, $BillExpensesTable, BillExpense>,
          ),
          BillExpense,
          PrefetchHooks Function()
        > {
  $$BillExpensesTableTableManager(_$DriftClient db, $BillExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> description = const Value.absent(),
              }) => BillExpensesCompanion(
                id: id,
                category: category,
                amount: amount,
                date: date,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String category,
                required double amount,
                required DateTime date,
                required String description,
              }) => BillExpensesCompanion.insert(
                id: id,
                category: category,
                amount: amount,
                date: date,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BillExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$DriftClient,
      $BillExpensesTable,
      BillExpense,
      $$BillExpensesTableFilterComposer,
      $$BillExpensesTableOrderingComposer,
      $$BillExpensesTableAnnotationComposer,
      $$BillExpensesTableCreateCompanionBuilder,
      $$BillExpensesTableUpdateCompanionBuilder,
      (
        BillExpense,
        BaseReferences<_$DriftClient, $BillExpensesTable, BillExpense>,
      ),
      BillExpense,
      PrefetchHooks Function()
    >;
typedef $$FinancialTransactionsTableCreateCompanionBuilder =
    FinancialTransactionsCompanion Function({
      Value<int> id,
      required String type,
      required double amount,
      required DateTime transactionDate,
      required String description,
      Value<int?> relatedMemberId,
    });
typedef $$FinancialTransactionsTableUpdateCompanionBuilder =
    FinancialTransactionsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<double> amount,
      Value<DateTime> transactionDate,
      Value<String> description,
      Value<int?> relatedMemberId,
    });

final class $$FinancialTransactionsTableReferences
    extends
        BaseReferences<
          _$DriftClient,
          $FinancialTransactionsTable,
          FinancialTransaction
        > {
  $$FinancialTransactionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MembersTable _relatedMemberIdTable(_$DriftClient db) =>
      db.members.createAlias(
        $_aliasNameGenerator(
          db.financialTransactions.relatedMemberId,
          db.members.memberId,
        ),
      );

  $$MembersTableProcessedTableManager? get relatedMemberId {
    final $_column = $_itemColumn<int>('related_member_id');
    if ($_column == null) return null;
    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.memberId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_relatedMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FinancialTransactionsTableFilterComposer
    extends Composer<_$DriftClient, $FinancialTransactionsTable> {
  $$FinancialTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  $$MembersTableFilterComposer get relatedMemberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinancialTransactionsTableOrderingComposer
    extends Composer<_$DriftClient, $FinancialTransactionsTable> {
  $$FinancialTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$MembersTableOrderingComposer get relatedMemberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinancialTransactionsTableAnnotationComposer
    extends Composer<_$DriftClient, $FinancialTransactionsTable> {
  $$FinancialTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  $$MembersTableAnnotationComposer get relatedMemberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinancialTransactionsTableTableManager
    extends
        RootTableManager<
          _$DriftClient,
          $FinancialTransactionsTable,
          FinancialTransaction,
          $$FinancialTransactionsTableFilterComposer,
          $$FinancialTransactionsTableOrderingComposer,
          $$FinancialTransactionsTableAnnotationComposer,
          $$FinancialTransactionsTableCreateCompanionBuilder,
          $$FinancialTransactionsTableUpdateCompanionBuilder,
          (FinancialTransaction, $$FinancialTransactionsTableReferences),
          FinancialTransaction,
          PrefetchHooks Function({bool relatedMemberId})
        > {
  $$FinancialTransactionsTableTableManager(
    _$DriftClient db,
    $FinancialTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialTransactionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$FinancialTransactionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FinancialTransactionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int?> relatedMemberId = const Value.absent(),
              }) => FinancialTransactionsCompanion(
                id: id,
                type: type,
                amount: amount,
                transactionDate: transactionDate,
                description: description,
                relatedMemberId: relatedMemberId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required double amount,
                required DateTime transactionDate,
                required String description,
                Value<int?> relatedMemberId = const Value.absent(),
              }) => FinancialTransactionsCompanion.insert(
                id: id,
                type: type,
                amount: amount,
                transactionDate: transactionDate,
                description: description,
                relatedMemberId: relatedMemberId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FinancialTransactionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({relatedMemberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (relatedMemberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.relatedMemberId,
                                referencedTable:
                                    $$FinancialTransactionsTableReferences
                                        ._relatedMemberIdTable(db),
                                referencedColumn:
                                    $$FinancialTransactionsTableReferences
                                        ._relatedMemberIdTable(db)
                                        .memberId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FinancialTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$DriftClient,
      $FinancialTransactionsTable,
      FinancialTransaction,
      $$FinancialTransactionsTableFilterComposer,
      $$FinancialTransactionsTableOrderingComposer,
      $$FinancialTransactionsTableAnnotationComposer,
      $$FinancialTransactionsTableCreateCompanionBuilder,
      $$FinancialTransactionsTableUpdateCompanionBuilder,
      (FinancialTransaction, $$FinancialTransactionsTableReferences),
      FinancialTransaction,
      PrefetchHooks Function({bool relatedMemberId})
    >;
typedef $$AttendanceRecordsTableCreateCompanionBuilder =
    AttendanceRecordsCompanion Function({
      Value<int> id,
      required int memberId,
      required DateTime checkInTime,
    });
typedef $$AttendanceRecordsTableUpdateCompanionBuilder =
    AttendanceRecordsCompanion Function({
      Value<int> id,
      Value<int> memberId,
      Value<DateTime> checkInTime,
    });

final class $$AttendanceRecordsTableReferences
    extends
        BaseReferences<
          _$DriftClient,
          $AttendanceRecordsTable,
          AttendanceRecord
        > {
  $$AttendanceRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MembersTable _memberIdTable(_$DriftClient db) =>
      db.members.createAlias(
        $_aliasNameGenerator(
          db.attendanceRecords.memberId,
          db.members.memberId,
        ),
      );

  $$MembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<int>('member_id')!;

    final manager = $$MembersTableTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.memberId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttendanceRecordsTableFilterComposer
    extends Composer<_$DriftClient, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnFilters(column),
  );

  $$MembersTableFilterComposer get memberId {
    final $$MembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceRecordsTableOrderingComposer
    extends Composer<_$DriftClient, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnOrderings(column),
  );

  $$MembersTableOrderingComposer get memberId {
    final $$MembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceRecordsTableAnnotationComposer
    extends Composer<_$DriftClient, $AttendanceRecordsTable> {
  $$AttendanceRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => column,
  );

  $$MembersTableAnnotationComposer get memberId {
    final $$MembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MembersTableAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceRecordsTableTableManager
    extends
        RootTableManager<
          _$DriftClient,
          $AttendanceRecordsTable,
          AttendanceRecord,
          $$AttendanceRecordsTableFilterComposer,
          $$AttendanceRecordsTableOrderingComposer,
          $$AttendanceRecordsTableAnnotationComposer,
          $$AttendanceRecordsTableCreateCompanionBuilder,
          $$AttendanceRecordsTableUpdateCompanionBuilder,
          (AttendanceRecord, $$AttendanceRecordsTableReferences),
          AttendanceRecord,
          PrefetchHooks Function({bool memberId})
        > {
  $$AttendanceRecordsTableTableManager(
    _$DriftClient db,
    $AttendanceRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> memberId = const Value.absent(),
                Value<DateTime> checkInTime = const Value.absent(),
              }) => AttendanceRecordsCompanion(
                id: id,
                memberId: memberId,
                checkInTime: checkInTime,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int memberId,
                required DateTime checkInTime,
              }) => AttendanceRecordsCompanion.insert(
                id: id,
                memberId: memberId,
                checkInTime: checkInTime,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttendanceRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (memberId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.memberId,
                                referencedTable:
                                    $$AttendanceRecordsTableReferences
                                        ._memberIdTable(db),
                                referencedColumn:
                                    $$AttendanceRecordsTableReferences
                                        ._memberIdTable(db)
                                        .memberId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttendanceRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$DriftClient,
      $AttendanceRecordsTable,
      AttendanceRecord,
      $$AttendanceRecordsTableFilterComposer,
      $$AttendanceRecordsTableOrderingComposer,
      $$AttendanceRecordsTableAnnotationComposer,
      $$AttendanceRecordsTableCreateCompanionBuilder,
      $$AttendanceRecordsTableUpdateCompanionBuilder,
      (AttendanceRecord, $$AttendanceRecordsTableReferences),
      AttendanceRecord,
      PrefetchHooks Function({bool memberId})
    >;

class $DriftClientManager {
  final _$DriftClient _db;
  $DriftClientManager(this._db);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db, _db.members);
  $$BillExpensesTableTableManager get billExpenses =>
      $$BillExpensesTableTableManager(_db, _db.billExpenses);
  $$FinancialTransactionsTableTableManager get financialTransactions =>
      $$FinancialTransactionsTableTableManager(_db, _db.financialTransactions);
  $$AttendanceRecordsTableTableManager get attendanceRecords =>
      $$AttendanceRecordsTableTableManager(_db, _db.attendanceRecords);
}
